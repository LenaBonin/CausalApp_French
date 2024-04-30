function(values){div(class = 'container',
                     h3("Facteurs de confusion"),
                     htmlOutput("QconfusionExpOutMed"),
                     img(src="Confusion_Exp_Out.png", width="30%"),
                     radioButtons("ConfuExpOutMed","Apparaissent-ils tous sur votre DAG ?",
                                  choices = c("Oui", "Non"),
                                  selected = values$ConfuExpOutMed),
                     
                     br(),
                     
                     htmlOutput("QconfusionExpMedMed"),
                     img(src="Confusion_Exp_Med.png", width="30%"),
                     radioButtons("ConfuExpMedMed","Apparaissent-ils tous sur votre DAG ?",
                                  choices = c("Oui", "Non"),
                                  selected = values$ConfuExpMedMed),
                     
                     br(),
                     
                     htmlOutput("QconfusionMedOutMed"),
                     img(src="Confusion_Med_Out.png", width="30%"),
                     radioButtons("ConfuMedOutMed","Apparaissent-ils tous sur votre DAG ?",
                                  choices = c("Oui", "Non"),
                                  selected = values$ConfuMedOutMed),
                     
                     br(),
                     
                     radioButtons("ConfuNonMesureMed","Certains de ces facteurs sont-ils non mesurés dans vos données ?",
                                  choices = c("Oui", "Non"),
                                  selected = values$ConfuNonMesureMed),
                     
                     br(),
                     htmlOutput("ConfuInfluence"),
                     img(src="Confusion_intermediaire.png", width="30%"),
                     radioButtons("ConfuInfluence","",
                                  choices = c("Oui", "Non"),
                                  selected = ifelse(is.null(values$ConfuInfluence), "Non", values$ConfuInfluence)),
                     
                     conditionalPanel(
                       condition = "input.ConfuInfluence == 'Oui'",
                       div(
                         class = "additional-question",
                         radioButtons("ShortTime", "Le temps entre l'observation de l'exposition et celle du médiateur est-il très court?",
                                    choices = c("Oui", "Non"),
                                    selected = values$ShortTime)
                       )
                     ),
                     
                     conditionalPanel(
                       condition = "input.ShortTime == 'Non' & input.ConfuInfluence == 'Oui'",
                       div(
                         class = "additional-question-2",
                         radioButtons("add_hyp_cond", "L'hypothèse suivante vous parait-elle crédible ? \n
                                      Conditionnellement à (i.e. après ajustement sur) l'exposition, le médiateur et le facteur de confusion intermédiaire, il n'y a pas de facteur de confusion non mesuré de la relation médiateur-outcome",
                                      choices = c("Oui", "Non"),
                                      selected = values$add_hyp_cond)
                       )
                     ),
                     
                     
                     br(),
                     actionButton("Confu_Med_Prev", "< Précédent"),
                     actionButton("Confu_Med_Next", "Suivant >"),
                     br()
)
}