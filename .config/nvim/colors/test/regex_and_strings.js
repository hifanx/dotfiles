const plain = "plain string value";
const escaped = "line1\nline2\tend";
const template = `path: ${plain}`;

const regex = /foo\d+/g;
const rawRegex = String.raw`^foo\\w+bar$`;

const filePath = "/usr/local/bin/node";
const website = "https://example.com/path";

const sym = Symbol("demo-symbol");

class Box {
  constructor(value) {
    this.value = value;
  }

  getValue() {
    return this.value;
  }
}

function useAll(x) {
  if (regex.test(plain)) {
    console.log(website, filePath, sym);
  }

  const box = new Box(x ? escaped : plain);
  const result = box.getValue();

  return x ? result : template;
}
