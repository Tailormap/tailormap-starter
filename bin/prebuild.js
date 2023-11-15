const chalk = require('chalk');
const path = require('path');
const fs = require('fs');

const { version: appVersion } = require('../node_modules/@tailormap-viewer/core/package.json');

try {
  const file = path.resolve(__dirname, '../dist/app/', 'version.json');
  const version = JSON.stringify({version: appVersion, buildDate: Date()}, null, 2);
  fs.writeFileSync(file, version, {encoding: 'utf-8'});
  console.log(chalk.green(`Wrote version info ${appVersion} to ${path.relative(path.resolve(__dirname, '..'), file)}`));
} catch(e) {
  console.log(chalk.red('Error writing version and git info'), e);
}
