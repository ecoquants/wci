shinyServer(function(input, output) {
  
  output$lat <- renderPrint({
    input$lat
  })
  
  output$lon <- renderPrint({
    input$lon
  })
  
  output$geolocation <- renderPrint({
    input$geolocation
  })
  
  address2lonlat = reactive({
    # geocode: address to lon,lat
    geocode(input$address)
  })
  
  output$map <- renderLeaflet({
    
    p = address2lonlat()
    
    # input = list(address='812 W Sola St, Santa Barbara CA'); p = geocode(input$address)
    leaflet(sb100) %>%
      addProviderTiles('Stamen.TonerLite') %>%
      #addProviderTiles('Stamen.Terrain') %>%
      addPolygons() %>%
      #setView(
      #  p$lon, p$lat, zoom=10) %>%
      addMarkers(
        p$lon, p$lat, popup=sprintf('%s<br>\n( %g, %g )', input$address, p$lon, p$lat))

  })
  
  # TODO: model window of climatic rain
  
  output$plot_practices <- renderPlot({
    
    practices = c(
      'Storage'        = 'storage',
      'Catchment'      = 'catchment',
      'Infiltration'   = 'infiltration',
      'Reduction'      = 'reduction',
      'Grey Water'     = 'greywater',
      'Native Habitat' = 'nativehabitat',
      'Edible Gardens' = 'ediblegardens')
  
    # input = list(sldr_storage=0.1, sldr_catchment=0.1, sldr_infiltration=0.1, sldr_reduction=0.1, sldr_greywater=0.1, sldr_nativehabitat=0.1, sldr_ediblegardens=0.1)
    sldr_enhancements = c(
      input$sldr_storage,
      input$sldr_catchment,
      input$sldr_infiltration,
      input$sldr_reduction,
      input$sldr_greywater,
      input$sldr_nativehabitat,
      input$sldr_ediblegardens)
    
    d = tibble(
      practice          = practices,
      score_native      = scores_random,
      enhancement       = sldr_enhancements) %>%
      mutate(
        score_enhance   = (1 - score_native) * enhancement)
    
    d = bind_rows(
      d %>%
        select(practice, score = score_native) %>%
        mutate(
          type = 'native'),
      d %>%
        select(practice, score = score_enhance) %>%
        mutate(
          type = 'enhancement'))
      
    
    g = ggplot(d, aes(x=practice, y=score, fill=practice, alpha=type)) + 
      geom_col() + 
      scale_alpha_manual(values = c('native'=0.5, 'enhancement'=0.9))
    
    if (input$radio_plot_type == 'polar'){
      g = g + coord_polar()
    }
    
    g
  })
  
  
})
