UI <- function() {
  
  page_navbar(
    id = "pageid",
    
    # Theming
    title="Portfolio Management Tool",
    window_title="Portfolio Management Tool",
    theme=bs_theme(
      bootswatch="cosmo",
      fg="#ffffff",
      bg="#0d1821",
      primary="#344966",
      secondary="#3b434c",
      info="#77B300",
      success="#77B300",
      danger="#CC0000"
    ),
    lang="en",
    # e_theme_register("code/charting/echarts/pmt.json", name="pmtTheme"),
    
    # Sidebar
    sidebar = SidebarUI("sidebar"),
    
    # Summary page
    nav_panel(
      title="Summary", 
      SummaryUI("summary")
    ),
    
    # Performance page
    nav_panel(
      title="Performance", 
      PerformanceUI("performance")
    ),
    
    # Risk page
    nav_panel(
      title="Risk", 
      RiskUI("risk")
    ),
    
    # Tracking page
    nav_panel(
      title="Tracking", 
      TrackingUI("tracking")
    )
    
  )
  
}