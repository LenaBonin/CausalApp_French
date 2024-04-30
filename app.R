library(shiny)
library(shinyjs)
library(shinyalert)
library(tidyverse)
library(DT)

source("Questions/Questionnaire_Obj_UI.R")
source("Questions/Questionnaire_TotalEffect_UI.R")
source("Questions/Questionnaire_Mediation_UI.R")
source("Recommandations/Recommandations_UI.R")



ui <- fluidPage(
  
  useShinyjs(),
  withMathJax(), # To include inline math equations
  # Settings pour définir des questions conditionnelles
  tags$head(
    tags$style(HTML("
      .additional-question {
        margin-left: 50px; /* Ajoutez la valeur de décalage souhaitée ici */
      }
      
      .additional-question-2 {
        margin-left: 100px; /* Ajoutez la valeur de décalage souhaitée ici */
      }
    ")),
    
  ),

  shinyUI(
    navbarPage( "Causal app Fr",
                # Setting for the nav bar (colors)
                tags$style(HTML(" 
                .navbar-default .navbar-brand {color: white;}
                .navbar-default .navbar-brand:hover {color: white;}
                .navbar { background-color: #7c1444 ;}
                .navbar-default .navbar-nav > li > a {color:white;}
                .navbar-default .navbar-nav > .active > a,
                .navbar-default .navbar-nav > .active > a:focus,
                .navbar-default .navbar-nav > .active > a:hover {color: white;background-color: #9c456c;}
                .navbar-default .navbar-nav > li > a:hover {color: white ;background-color:#bc7c94; text-decoration:underline;}
                .shiny-text-output { background: none; border: none; padding: 0; margin: 0; white-space: nowrap; }
                  ")), # Ou active color #923860
                
                # Tabs
                tabPanel("Accueil",
                         source("Accueil.R")$value),
                tabPanel("Questionnaire",
                         uiOutput("page")),
                tabPanel("Ressources", source('Ressources.R')$value),
                selected = "Accueil"
    )
  )
)




# Define server logic required to draw a histogram
server <- function(input, output, session) {
  
  # Vecteur des valeurs rentrées par l'utilisateur dans le questionnaire, afin de garder en mémoire les réponses quand on revient en arrière
  values <- reactiveValues(question1 = NULL, question2 = NULL,
                           
                           # Effet total
                           ExpoTot = "", OutTot = "",
                           TypExpTot = NULL, TypOutcomeTot = NULL,
                           ConfuTot = NULL, ConfuNonMesureTot = NULL,
                           MedExpOutTot = NULL, CollidExpOutTot = NULL,
                           ExpRepTot = NULL, ConfRepTot = NULL, OutRepTot = NULL,
                           QPosiTot = NULL,
                           
                           ##Médiation
                           Expo = "", Mediateur = "", Outcome="", 
                           ObjMedA1 = NULL, ObjMedA2 = NULL, ObjMedA3 = NULL, #ObjMedA0 = NULL,
                           ObjMedB1 = NULL, ObjMedB2 = NULL, ObjMedB3 = NULL, ObjMedB4 = NULL,
                           TypExpMed = NULL, TypMediateurMed = NULL, TypOutcomeMed = NULL, EffetTotVerif = NULL, RareOutcome=NULL,
                           ExpRepMed = NULL, MediateurRepMed = NULL, OutRepMed = NULL,
                           ConfuExpOutMed = NULL, ConfuExpMedMed = NULL, ConfuMedOutMed = NULL, ConfuNonMesureMed = NULL, ConfuInfluence = NULL, 
                           ShortTime = NULL, add_hyp_cond = NULL,
                           CollidExpOutMediation = NULL, CollidMedOut = NULL,
                           PosiExpMed = NULL, PosiMedMed = NULL,
                           InteractionExpMed = NULL, InteractionDirIndir = NULL
                           )
  
  # Vecteur des données résumé de la sélection pour l'effet total
  # (utilisé pour afficher la sélection avant les recommandations dans le document téléchargeable)
  SelectionTotal <- reactiveValues(VarType = NULL, Obj = NULL, Constraint = NULL)
  SelectionMediation <- reactiveValues(VarType = NULL, Obj = NULL, Interaction = NULL,
                                       ConstraintVar = NULL, ConstraintConf = NULL, ConstraintPos = NULL)
  
  # Fonction pour définir la page à afficher dans le questionnaire
  currentPage <- reactiveVal("Qprelim")
  
  # Afficher la bonne page
  output$page <- renderUI({
    current_page <- currentPage()
    if (current_page == "Qprelim") {
      Qprelim()
    } else {
      render_page(paste0(current_page, ".R"), values = values)
    }
  })
  
  # Chargement et exécution des fichiers "_server"
  source("Questions/Questionnaire_Obj_Server.R", local = T)
  observe_events_Objectifs(input, output, session, currentPage, values)
  source("Questions/Questionnaire_TotalEffect_Server.R", local = T)$value 
  observe_events_TotalEffect(input, output, session, currentPage, values, SelectionTotal)
  source("Questions/Questionnaire_Mediation_Server.R", local = T)$value 
  observe_events_Mediation(input, output, session, currentPage, values, SelectionMediation)
  source("Recommandations/Recommandations_Server.R")
  observe_events_Recommandations(input, output, session, currentPage, values, SelectionMediation)
  source("Recommandations/Recommandations_TotalEffect_Server.R")
  observe_events_Recommandations_Tot(input, output, session, currentPage, values, SelectionTotal)
  
}

# Run the application 
shinyApp(ui = ui, server = server)
