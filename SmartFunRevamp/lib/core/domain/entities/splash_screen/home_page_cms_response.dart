import 'package:json_annotation/json_annotation.dart';
part 'home_page_cms_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.pascal, explicitToJson: true)
class HomePageCMSResponse {
  final int? moduleId;
  final String? description;
  final String? title;
  @JsonKey(name: 'CMSModulePageDTOList')
  final List<CMSModulePage>? cmsModulePages;
  @JsonKey(name: 'CMSModuleMenuDTOList')
  final List<CMSModuleMenu> cmsModuleMenu;

  @JsonKey(name: 'images')
  final CMSImages cmsImages;

  HomePageCMSResponse(
    this.moduleId,
    this.description,
    this.title,
    this.cmsModulePages,
    this.cmsModuleMenu,
    this.cmsImages,
  );
  factory HomePageCMSResponse.fromJson(Map<String, dynamic> json) => _$HomePageCMSResponseFromJson(json);
  Map<String, dynamic> toJson() => _$HomePageCMSResponseToJson(this);

  List<CMSMenuItem> geMenuItems(String type) {
    List<CMSMenuItem> cmsMenuItems = [];
    for (CMSModuleMenu moduleMenu in cmsModuleMenu) {
      for (CMSMenu menu in moduleMenu.cmsMenus) {
        if (menu.type == type) {
          cmsMenuItems = menu.cmsMenuItems;
        }
      }
    }
    cmsMenuItems.sort((a, b) => a.displayOrder < b.displayOrder ? -1 : 1);
    return cmsMenuItems;
  }

  List<CMSMenuItem> getFooterMenuItems() {
    return geMenuItems('FOOTER');
  }

  List<CMSMenuItem> getCardDetailMenuItems() {
    return geMenuItems('CARD_DETAILS');
  }

  List<CMSMenuItem> getMoreMenuItems() {
    return geMenuItems('MORE');
  }
}

@JsonSerializable(fieldRename: FieldRename.pascal, explicitToJson: true)
class CMSModulePage {
  final int pageId;
  final int contentId;
  final String displaySection;
  final int displayOrder;
  final String contentURL;
  CMSModulePage(
    this.pageId,
    this.contentId,
    this.displaySection,
    this.displayOrder,
    this.contentURL,
  );

  Map<String, dynamic> toJson() => _$CMSModulePageToJson(this);

  factory CMSModulePage.fromJson(Map<String, dynamic> json) => _$CMSModulePageFromJson(json);
}

@JsonSerializable(fieldRename: FieldRename.pascal, explicitToJson: true)
class CMSModuleMenu {
  @JsonKey(name: 'CMSMenusDTOList')
  final List<CMSMenu> cmsMenus;
  CMSModuleMenu(
    this.cmsMenus,
  );
  factory CMSModuleMenu.fromJson(Map<String, dynamic> json) => _$CMSModuleMenuFromJson(json);
  Map<String, dynamic> toJson() => _$CMSModuleMenuToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.pascal, explicitToJson: true)
class CMSMenu {
  @JsonKey(name: 'CMSMenuItemsDTOList')
  final List<CMSMenuItem> cmsMenuItems;
  final String name;
  final String type;
  final bool active;
  CMSMenu(
    this.cmsMenuItems,
    this.name,
    this.active,
    this.type,
  );
  factory CMSMenu.fromJson(Map<String, dynamic> json) => _$CMSMenuFromJson(json);
  Map<String, dynamic> toJson() => _$CMSMenuToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.pascal, explicitToJson: true)
class CMSMenuItem {
  final String itemName;
  final String displayName;
  final bool active;
  final int displayOrder;
  final String itemUrl;
  CMSMenuItem(
    this.itemName,
    this.displayName,
    this.active,
    this.displayOrder,
    this.itemUrl,
  );
  factory CMSMenuItem.fromJson(Map<String, dynamic> json) => _$CMSMenuItemFromJson(json);
  Map<String, dynamic> toJson() => _$CMSMenuItemToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.pascal, explicitToJson: true)
class CMSImages {
  @JsonKey(name: 'splash_screen_image_path')
  final String splashScreenPath;
  @JsonKey(name: 'language_pick_image_path')
  final String languagePickImagePath;
  CMSImages(this.splashScreenPath, this.languagePickImagePath);
  factory CMSImages.fromJson(Map<String, dynamic> json) => _$CMSImagesFromJson(json);
  Map<String, dynamic> toJson() => _$CMSImagesToJson(this);
}
