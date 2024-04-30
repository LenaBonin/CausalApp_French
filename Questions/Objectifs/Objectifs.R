function(values){
div(class = 'container',
        h3("Votre objectif est-il du type :"),
    p("(Les variables proposées dans les deux phrases suivantes ne sont que des exemples, et pourront ensuite être remplacées par vos propres variables)"),
        radioButtons("question1", "Etudier l'effet de la classe sociale sur la mortalité",
                     choices = c("Oui", "Non"),
                     selected = values$question1),
        br(),
    
    
    radioButtons("question2", "Etudier le rôle du tabac comme intermédiaire entre la classe sociale et la mortalité", 
                 choices = c("Oui", "Non"), 
                 selected = values$question2),
    br(),
    actionButton("EndObj1Prev", "< Précédent"),
    actionButton("EndObj1Next", "Suivant >"),
    br()
    )
}

