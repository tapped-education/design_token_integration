
# Design Tokens


> The Design Tokens plugin for Figma allows you to export design tokens into a json format that can be used with the Amazon style dictionary package. This allows you to transform your tokens to different languages / platforms like web, iOS or Android.

For more informations, you can check out the [repository](https://github.com/lukasoppermann/design-tokens).


## Generate TextStyles, Colors and other definitions from Figma

Figma design tokens can be used to generate TextStyles, colors or spacings from Figma.

There are few helpful articles that explains how to work with design tokens.

1. https://amzn.github.io/style-dictionary/#/token
2. https://tokens.studio/

To work with design tokens, we need to generate some Dart files, that we use in our application. When you received a new
design token file, from any designer you need to do several things:

1. Replace the config json files in corresponding branding (e.g. styling/design_tokens)
2. Jump with the terminal into the directory `cd styling/style_directory`
3. Enter `npm install` in the terminal
4. Execute `generate_design_tokens.sh`

🎉 The new dart files should be generated.

---
