function(values){ 
  div(class = 'container',
      h3("Interaction entre l'exposition et le médiateur"),
      htmlOutput("QInteractionExpMed"),
      radioButtons("InteractionExpMed","",
                   choices = c("Oui", "Non"),
                   selected = values$InteractionExpMed),
      
      br(),
      conditionalPanel(
        condition = "input.InteractionExpMed == 'Non'",
        div(
          class = "additional-question",
          radioButtons("InteractionDirIndir", "Si cette interaction existe, souhaitez-vous qu'elle soit prise en compte dans l'effet ",
                       choiceNames = c("Direct (qui ne passe pas par le facteur intermédiaire)",
                                       "Indirect (qui passe par le facteur intermédiaire)"),
                       choiceValues = c("Direct", "Indirect"),
                       selected = values$InteractionDirIndir)
        )
      ),
      
      
      actionButton("Interaction_Med_Prev", "< Précédent"),
      actionButton("Interaction_Med_Next", "Suivant >"),
      br()
  )
}