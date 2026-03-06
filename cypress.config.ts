import { defineConfig } from 'cypress'

export default defineConfig({
  defaultCommandTimeout: 60000,
  env: {
    backendUrl:
      'https://api.conjob.io/job/run?image=scottg489/metadiff:latest&remove=true'
  },
  e2e: {
    setupNodeEvents (on, config) {},
    baseUrl: 'http://localhost:3000'
  }
})
