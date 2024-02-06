pushd ./styling/styling_dictionary || exit
npm install
echo "Generating files"
npm run build lightTokens=../design_tokens/tokens_light.json darkTokens=../design_tokens/tokens_dark.json outputFolder=styling/lib/generated/
popd || exit
