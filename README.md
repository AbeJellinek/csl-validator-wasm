# csl-validator-wasm

A validator for [Citation Style Language](https://citationstyles.org/) styles. This is built on a WebAssembly compilation of [rnv](https://sourceforge.net/projects/rnv/).

csl-validator-wasm was inspired by Simon Kornblith's [csl-validator.js](https://github.com/simonster/csl-validator.js). This project uses newer versions of its libraries, compiles to WebAssembly (versus asm.js), and can be built reproducibly on any machine using Docker. The two libraries should function more or less the same.

## Installation

### Using npm

```bash
npm install csl-validator-wasm
```

### From source

1. Ensure you have Docker installed and the Docker daemon running.
2. Run `./build.sh`
3. Wait.
4. Copy the contents of `/dist` to your project.

If your web server serves WASM with the correct MIME type, consider removing the `WASM_ASYNC_COMPILATION=0` compilation flag in `build_rnv.sh`.

## Usage

### As an ES module

```js
import { validateStyle } from './csl-validator.mjs';

let yourStyleXML = '...';
let output = validateStyle(yourStyleXML);

if (output.length) {
    // Errors!
}
```

### As a worker

```js
let worker = new Worker('/path/to/dist/worker.mjs', { type: 'module' });
worker.onmessage = function (event) {
    if (event.data) {
        // Errors!
    }
};
worker.postMessage(style);
```

## License

The original code in this repository is licensed under the AGPL3. See [LICENSE.txt](LICENSE.txt). The third-party libraries and bundled files are made available under their own licenses. See [LICENSE_LIBS.txt](LICENSE_LIBS.txt).
