function(values){
  
  div(class = 'container',
      h3("Type des variables"),
      radioButtons("TypExpTot", "Quelle est la nature de votre variable d'exposition ? ", 
                   choices = c("Quantitative", "Binaire", "Ordinale", "Nominale", "J'en ai plusieurs"), 
                   selected = values$TypExpTot),
      br(),
      textAreaInput(
        inputId = "ExpoTot",
        label = "Quel est le nom de cette variable ?",
        value = values$ExpoTot,
        width = '100%',
        height = '1000%',
        placeholder = "La classe sociale"
      ),
      
      br(), 
      radioButtons("TypOutcomeTot", "Quelle est la nature de votre outcome ?", 
                   choices = c("Quantitative", "Binaire", "Ordinale", "Nominale", "Survie / Time-to-event", "J'en ai plusieurs"),
                   selected = values$TypOutcomeTot),
      br(),
      textAreaInput(
        inputId = "OutTot",
        label = "Quel est le nom de cette variable ?",
        value = values$OutTot,
        width = '100%',
        height = '1000%',
        placeholder = "La mortalité"
      ),
      br(),
      actionButton("Var_Tot_Prev", "< Précédent"),
      actionButton("Var_Tot_Next", "Suivant >"),
      br()
  )
  
}