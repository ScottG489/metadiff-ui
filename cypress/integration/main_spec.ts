describe('Submitting diff input text', () => {
  it('Should fill out appropriate fields', () => {
    cy.visit('/')

    cy.contains('Yeet').click()

    cy.contains(/To File:.*\.gitignore/)
    cy.contains(/From File:.*\.gitignore/)
    cy.contains(/File Status:.*Modified/)
  })
})