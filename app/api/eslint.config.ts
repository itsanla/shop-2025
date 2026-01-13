import eslint from '@eslint/js';
import tseslint from 'typescript-eslint';
import stylistic from '@stylistic/eslint-plugin';
import nodePlugin from 'eslint-plugin-n';
import promisePlugin from 'eslint-plugin-promise'; 

export default tseslint.config(
  eslint.configs.recommended,
  nodePlugin.configs['flat/recommended-script'],
  ...tseslint.configs.strictTypeChecked, 
  ...tseslint.configs.stylisticTypeChecked,
  
  // Konfigurasi Global
  {
    ignores: [
      '**/node_modules/*',
      '**/*.mjs',
      '**/*.js',
      'dist',
      'coverage'
    ],
  },
  {
    languageOptions: {
      parserOptions: {
        project: './tsconfig.json',
        tsconfigRootDir: __dirname, // Agar path tsconfig akurat
        warnOnUnsupportedTypeScriptVersion: false,
      },
    },
  },
  // Load Plugins
  {
    plugins: {
      '@stylistic': stylistic,
      'promise': promisePlugin, 
    },
  },
  {
    files: ['**/*.ts'],
    rules: {
      // --- 1. ATURAN PROMISE & ASYNC (ANTI-BLOCKING) ---

      // Wajib await untuk fungsi async (mencegah lupa await)
      '@typescript-eslint/no-floating-promises': 'error', 
      
      // Mencegah penggunaan promise di tempat yang salah (misal if(promise))
      '@typescript-eslint/no-misused-promises': 'error',
      
      // Wajib return nilai di dalam .then()
      'promise/always-return': 'warn',
      
      // Wajib handle error (.catch)
      'promise/catch-or-return': 'warn',
      
      // Lebih baik pakai async/await daripada .then().then()
      'promise/prefer-await-to-then': 'warn',
      'promise/prefer-await-to-callbacks': 'warn',

      // --- 2. ATURAN LAINNYA  ---
      '@typescript-eslint/explicit-member-accessibility': 'off', 
      '@typescript-eslint/no-confusing-void-expression': 'off',
      '@typescript-eslint/no-unnecessary-condition': 'warn',
      
      '@typescript-eslint/restrict-template-expressions': [
        'error', { allowNumber: true, allowBoolean: true },
      ],
      
      '@typescript-eslint/no-unused-vars': [
        'warn',
        { argsIgnorePattern: '^_', varsIgnorePattern: '^_' },
      ],

      // Styling (Titik koma, koma, dll)
      '@stylistic/semi': ['warn', 'always'],
      '@stylistic/member-delimiter-style': ['warn', {
        multiline: { delimiter: 'semi', requireLast: true },
        singleline: { delimiter: 'semi', requireLast: false },
      }],
      'comma-dangle': ['warn', 'always-multiline'],
      'indent': ['warn', 2],
      'quotes': ['warn', 'single'],

      // Node Rules
      'n/no-process-env': 'off', // saya matikan karena backend butuh process.env untuk Config
      'n/no-missing-import': 'off',
      'n/no-unpublished-import': 'off',
      
      'no-console': ['warn', { allow: ['info', 'error'] }], 
    },
  },
);