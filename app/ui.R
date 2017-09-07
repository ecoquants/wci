dashboardPage(
  skin='blue',
  
  dashboardHeader(
    titleWidth=250,
    title=span(tagList(icon('tint'), 'Water Commons Index - Micro App'))),
  
  dashboardSidebar(
    width=250,
    textInput('address', 'Address', '812 W Sola St, Santa Barbara CA'),
    h2('Enhancements'),
    sliderInput('sldr_storage', 'Storage', 0, 1, 0),
    sliderInput('sldr_catchment', 'Catchment', 0, 1, 0),
    sliderInput('sldr_infiltration', 'Infiltration', 0, 1, 0),
    sliderInput('sldr_reduction', 'Reduction', 0, 1, 0),
    sliderInput('sldr_greywater', 'Grey Water', 0, 1, 0),
    sliderInput('sldr_nativehabitat', 'Native Habitat', 0, 1, 0),
    sliderInput('sldr_ediblegardens', 'Edible Gardens', 0, 1, 0),
    radioButtons(
      'radio_plot_type', 'Plot Type', 
      choices = list('Column'='col', 'Polar'='polar'))
    ),
  
  dashboardBody(
    tags$head(tags$link(rel='stylesheet', type ='text/css', href='styles.css')),
    box(
      title='Map',  status='primary', solidHeader=T, 
      collapsible=T,
      leafletOutput('map')),
    box(
      title='Practices Score', status='info', solidHeader=T, 
      collapsible=T,
      plotOutput('plot_practices')))
)