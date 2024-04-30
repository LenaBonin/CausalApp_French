function(values){div(class = 'container',
                     h3("Facteurs de confusion"),
                     htmlOutput("QconfusionExpOutMed"),
                     img(src="Confusion_Exp_Out.png", width="30%"),
                     radioButtons("ConfuExpOutMed","Apparaissent-ils tous sur votre DAG ?",
                                  choices = c("Oui", "Non"),
                                  selected = values$ConfuExpOutMed),
                     
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
                     actionButton("Confu_Med_Prev", "< Précédent"),
                     actionButton("Confu_Med_CDE_Next", "Suivant >"),
                     br()
)
}