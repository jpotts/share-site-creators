var sitesMenu = widgetUtils.findObject(model.jsonModel, "id", "HEADER_SITES_MENU");
if (sitesMenu) {
  sitesMenu.config.showCreateSite = false;
}