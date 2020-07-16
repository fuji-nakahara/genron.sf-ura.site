module.exports = {
  env: {
    browser: true,
    es2020: true,
    node: true
  },
  extends: ['eslint:recommended', 'prettier'],
  parser: 'babel-eslint',
  parserOptions: {
    ecmaVersion: 11,
    sourceType: 'module'
  },
  rules: {}
}
