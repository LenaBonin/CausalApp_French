function(values){
  div(class = 'container',
      p("Dans l'exemple d'objectif précédent ('étudier l'effet du tabac comme intermédiaire dans la relation entre la classe sociale et la mortalité'), nous vous proposons de remplacer les variables par les vôtres."),
      p(" Si vous ne rentrez rien, les termes 'exposition', 'variable intermédiaire' et 'outcome' seront utilisés par la suite."),
      textAreaInput(
        inputId = "Expo",
        label = "Par quelle variable souhaitez-vous remplacer 'la classe sociale', i.e, quelle est votre variable d'exposition ?",
        value = values$Expo,
        width = '100%',
        height = '1000%',
        placeholder = "La classe sociale"
      ),
      
      textAreaInput(
        inputId = "Mediateur",
        label = "Par quelle variable souhaitez-vous remplacer 'le tabac', i.e, quelle est votre variable intermédiaire ?",
        value = values$Mediateur,
        width = '100%',
        height = '1000%',
        placeholder = "Le tabac"
      ),
      
      textAreaInput(
        inputId = "Outcome",
        label = "Par quelle variable souhaitez-vous remplacer 'la mortalité', i.e, quelle est votre variable d'intérêt / outcome ?",
        value = values$Outcome,
        width = '100%',
        height = '1000%',
        placeholder = "La mortalité"
      ),
      br(),
      actionButton("EndObj2Prev", "< Précédent"),
      actionButton("EndObj2Next", "Suivant >"),
      br()
  )
      
}