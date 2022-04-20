module.exports = {
  env: {
    browser: true,
    jest: true,
    es2021: true
  },
  extends: [
    'plugin:react/recommended',
    'plugin:cypress/recommended',
    'standard'
  ],
  parser: '@typescript-eslint/parser',
  settings: {
    react: {
      version: 'detect',
    }
  },
  parserOptions: {
    ecmaFeatures: {
      jsx: true
    },
    ecmaVersion: 'latest',
    sourceType: 'module'
  },
  plugins: [
    'react',
    '@typescript-eslint'
  ],
  rules: {
    'no-use-before-define': 'off'
  }
}
