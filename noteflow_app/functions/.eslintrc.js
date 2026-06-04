module.exports = {
  root: true,
  env: {
    es2021: true,
    node: true,
  },
  parser: "@typescript-eslint/parser",
  parserOptions: {
    sourceType: "module",
  },
  plugins: ["@typescript-eslint"],
  extends: [
    "eslint:recommended",
    "plugin:@typescript-eslint/recommended",
  ],
  rules: {
    "no-unused-vars": "off",
    "@typescript-eslint/no-unused-vars": ["warn", {argsIgnorePattern: "^_"}],
    "@typescript-eslint/no-explicit-any": "off",
  },
  ignorePatterns: ["lib/**", "node_modules/**", ".eslintrc.js"],
};
