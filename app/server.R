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
    #browser()
    
    leaflet(sb100) %>%
      addProviderTiles('Stamen.TonerLite', group = 'B&W') %>%
      addProviderTiles('Stamen.Terrain', group = 'Terrain') %>%
      addPolygons(group='Parcels') %>%
      setView(
        p$lon, p$lat, zoom=17) %>%
      addMarkers(
        p$lon, p$lat, 
        group='Address',
        popup=sprintf('%s<br>\n( %g, %g )', input$address, p$lon, p$lat)) %>%
      addLayersControl(
        baseGroups = c('Terrain','B&W'),
        overlayGroups = c('Parcels', 'Address'),
        options = layersControlOptions(collapsed=T))

  })
  
  
  get_data = reactive({
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
      practice          = factor(practices, practices, ordered=T),
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
  
    d
  })
  
  output$text_score <- renderUI({
    
    d = get_data()
    
    #browser()
    
    wci = d %>%
      group_by(practice) %>%
      summarize(
        score = sum(score)) %>%
      .$score %>%
      mean()
    
    #HTML(sprintf('WCI - Micro Score: %d (of 100)', round(wci*100)))
    HTML(sprintf('<h4>WCI - Micro Score: <b>%d</b> (of 100)</h4>', round(wci*100)))
    
  })
  
  output$plot_practices <- renderPlot({
    
    d = get_data()
    
    g = ggplot(d, aes(x=practice, y=score, fill=practice, alpha=type)) + 
      geom_col() + 
      scale_alpha_manual(values = c('native'=0.5, 'enhancement'=0.9))
    
    if (input$radio_plot_type == 'polar'){
      g = g + coord_polar()
    }
    
    g
  })
  
  
})
