describe('Submitting diff input text', () => {
  it('Should fill out appropriate fields', { retries: 3 }, () => {
    cy.visit('/')

    cy.contains('Yeet').click()

    cy.contains(/To File:.*\.gitignore/)
    cy.contains(/From File:.*\.gitignore/)
    cy.contains(/File Status:.*Modified/)
  })
})
