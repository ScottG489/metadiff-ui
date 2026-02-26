import { defineConfig } from 'cypress'

export default defineConfig({
  defaultCommandTimeout: 30000,
  env: {
    backendUrl:
      'https://api.conjob.io/job/run?image=scottg489/metadiff:latest&remove=true'
  },
  e2e: {
    setupNodeEvents (on, config) {},
    baseUrl: 'http://localhost:3000'
  }
})
