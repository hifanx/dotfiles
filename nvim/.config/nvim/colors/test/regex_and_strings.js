const plain = "plain string value"; // @string
const escaped = "line1\nline2\tend"; // '\\n', '\\t': @string.escape

const regex = /foo\d+/g; // /foo\d+/: @string.regexp, '\\d': @string.escape

const filePath = "/usr/local/bin/node"; // path-like string: @string.special.path
const website = "https://example.com/path"; // URL string: @string.special.url

const sym = Symbol("demo-symbol"); // "demo-symbol": @string.special.symbol (depending on grammar)

function useAll(x) {
  // function: @function
  if (regex.test(plain)) {
    // test(): @function.method.call
    console.log(website, filePath, sym); // console.log: @function.method.call
  }
  return x ? escaped : plain; // ternary uses @keyword.conditional.ternary
}
