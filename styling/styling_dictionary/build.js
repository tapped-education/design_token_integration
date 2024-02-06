const StyleDictionaryPackage = require('style-dictionary');
const fs = require('fs');
const path = require('path');
const _template = require('lodash/template');
const {
  fileHeader,
  sortByReference,
  createPropertyFormatter,
  sortByName
} = require('style-dictionary/lib/common/formatHelpers');

const {
  registerTransforms
} = require('@tokens-studio/sd-transforms');


function isNumeric(num) {
  return !isNaN(num)
}

function generateTokens(inputPath, outputPath, dartFileName, className) {

  registerTransforms(StyleDictionaryPackage);

  StyleDictionaryPackage.registerFilter({
    name: 'propertyFilter',
    matcher: function (prop) {
      let isFont = prop.type == "custom-fontStyle";
      // The important dimensions are just in the satellic map
      let isDimension = prop.type == "dimension" && prop.path.includes("primitives");
      // We just need the colors in the tokens
      let isColor = (prop.type == "color" && prop.path.includes("brand"));

      let matches = isFont || isDimension || isColor;
      return matches;
    }
  });

  StyleDictionaryPackage.registerTransform({
    name: 'dimensionNameTransformer',
    type: 'name',
    matcher: function (prop) {
      return prop.type == 'dimension';
    },
    transformer: function (prop) {
      return "dimension_" + transformPathToDartName(prop).replaceAll("primitives_", "");
    },
  });

  StyleDictionaryPackage.registerTransform({
    name: 'dimensionValueTransformer',
    type: 'value',
    matcher: function (prop) {
      return prop.type == 'dimension';
    },
    transformer: function (prop) {
      return prop.value.toFixed(1)
    },
  });

  StyleDictionaryPackage.registerTransform({
    name: 'colorNameTransformer',
    type: 'name',
    matcher: function (prop) {
      return prop.type == 'color';
    },
    transformer: function (prop) {
      return "color_" + transformPathToDartName(prop)
        .replaceAll("brand_surface_", "")
        .replaceAll("brand_text_", "")
        .replaceAll("brand_border_", "");
    },
  });

  StyleDictionaryPackage.registerTransform({
    name: 'customColorTransformer',
    type: 'value',
    matcher: function (prop) {
      return prop.type == 'color';
    },
    transformer: function (prop) {
      return StyleDictionaryPackage.transform['color/hex8flutter'].transformer(prop)
    },
  });

  StyleDictionaryPackage.registerTransform({
    name: 'fontNameTransformer',
    type: 'name',
    matcher: function (prop) {
      return prop.type == "custom-fontStyle";
    },
    transformer: function (prop) {
      return transformPathToDartName(prop);
    },
  });


  StyleDictionaryPackage.registerTransform({
    name: 'customFontTransformer',
    type: 'value',
    matcher: function (prop) {
      return prop.type == "custom-fontStyle";
    },
    transformer: function (prop) {
      const val = prop.value;
      let fontWeight = val.fontWeight;
      if (fontWeight == "Semi Bold") {
        fontWeight = "600";
      }
      return `TextStyle(
        fontSize: ${val.fontSize},
        fontWeight: FontWeight.w${fontWeight},
        fontFamily: '${val.fontFamily}',
        decoration: TextDecoration.${val.textDecoration},
        letterSpacing: ${val.letterSpacing},
        height: 1,
      )`;
    },
  });

  StyleDictionaryPackage.registerTransformGroup({
    name: 'tokens-dart',
    transforms: [
      'dimensionNameTransformer',
      'dimensionValueTransformer',
      'customColorTransformer',
      'colorNameTransformer',
      'fontNameTransformer',
      'customFontTransformer',
    ],
  });

  const StyleDictionaryConfig = {
    source: [inputPath],
    platforms: {
      'flutter/dart': {
        transformGroup: 'tokens-dart',
        buildPath: outputPath,
        prefix: '',
        files: [{
          'destination': dartFileName,
          'format': 'customFlutter',
          'filter': 'propertyFilter',
          'className': className,
        },],
      }
    }
  }
  const StyleDictionary = StyleDictionaryPackage.extend(StyleDictionaryConfig);


  StyleDictionary.registerFormat({
    name: 'customFlutter',
    formatter: function ({
      dictionary,
      platform,
      options,
      file
    }) {
      const template = _template(
        fs.readFileSync(__dirname + '/template/flutter_dart.template')
      );
      let allTokens;
      const {
        outputReferences
      } = options;
      const formatProperty = createPropertyFormatter({
        outputReferences,
        dictionary
      });

      if (outputReferences) {
        allTokens = [...dictionary.allTokens].sort(sortByReference(dictionary));
      } else {
        allTokens = [...dictionary.allTokens].sort(sortByName)
      }
      return template({
        allTokens,
        file,
        options,
        formatProperty,
        fileHeader
      });
    }
  });

  StyleDictionary.buildPlatform('flutter/dart');
}

let darkTokensFile = process.argv.find((arg) => arg.includes("darkTokens"))?.split("=")[1];
let lightTokensFile = process.argv.find((arg) => arg.includes("lightTokens"))?.split("=")[1];
let outputFolder = process.argv.find((arg) => arg.includes("outputFolder"))?.split("=")[1];

if (darkTokensFile == null) {
  console.error("Please specify a token file using \"darkTokens=./tokens/dark_tokens.json");
  process.exit(-1);
}

if (lightTokensFile == null) {
  console.error("Please specify a token file using \"lightTokens=./tokens/light_tokens.json");
  process.exit(-1);
}

if (outputFolder == null) {
  console.error("Please specify a output folder \"outputFolder=./lib/generated/");
  process.exit(-1);
}

generateTokens(darkTokensFile, "../../" + outputFolder, "dark_theme.g.dart", "DarkTheme")
generateTokens(lightTokensFile, "../../" + outputFolder, "light_theme.g.dart", "LightTheme")


function transformPathToDartName(prop) {
  let string = prop.path.map((element, index) => {
    // Append a "s" since names can not start with a number in dart.
    if (index == 0 && isNumeric(element)) {
      return "s" + element;
    }

    let replacedElement = element.replace(/[^a-zA-Z0-9\s]/g, ' ')

    return replacedElement
  })
    .join(" ")
    .replaceAll("-", "_") // replace the minus with an underline, since a minus is not valid in a name
    .replaceAll(" ", "_") // replace the empty space with a underline
    .replaceAll("__", "_") // remove duplicate underlines
    .replace(/[_]+$/, ''); // remove the underlines at the end of the string

  return string.charAt(0).toLowerCase() + string.slice(1);
}

function hexToDecimalColor(hexColor) {
  // Remove the "#" symbol if it's included in the hex color
  const hexWithoutHash = hexColor.replace("#", "");

  // Parse the hex color value to decimal for red, green, and blue components
  const redDecimal = parseInt(hexWithoutHash.substring(0, 2), 16);
  const greenDecimal = parseInt(hexWithoutHash.substring(2, 4), 16);
  const blueDecimal = parseInt(hexWithoutHash.substring(4, 6), 16);
  const alphaDecimal = parseInt(hexWithoutHash.substring(6, 8), 16);

  return `Color.fromARGB(${alphaDecimal}, ${redDecimal}, ${greenDecimal}, ${blueDecimal})`;
}
