/**
 * Mainly used as a namespace.
 * @param {type} type string. The type distinction is needed for removing un-needed keys
 * @param {hash} object. The json object being worked currently. 
 */
export default class PurgeKeys {
  constructor(type, hash){ 
    this.type = type;
    this.obj = hash;
    // arrays
    this.common_keys = [ "field_id", "type", "name", "label", "value", "placeholder", "css_id", "css_class", "sort_order", "local_styles", "metadata_standards", "help_type", "help_url", "help_info", "required", "no_duplicates", "read_only", "disabled", "disabled_on_insert", "disabled_on_update", "public_release", "oai_release", "sortable", "searchable", "display_in_list", "hidden", "validation", "validation_regex" ];
    this.idno_keys = ["managed_by", "idno_format", "start_increment"]; 
    this.text_keys = ["min", "max", "format"];
    this.number_keys = ["step", "min_number", "max_number"];
    this.choice_keys = ["choice_type", "default_choice", "choice_array", "choices", "choice_form", "choice_form_field"];
    this.file_keys = ["allowed_file_types", "multiple_files", "combine", "ocr", "convert", "thumbnail", "watermark", "border", "convert_audio", "convert_video", "video_thumbnail", "image_height", "image_width", "image_resolution", "image_format", "thumbnail_height", "thumbnail_width", "thumbnail_resolution", "thumbnail_format", "border_height", "border_width", "watermark_image", "watermark_location", "audio_bitrate", "audio_format", "video_bitrate", "video_format", "video_height", "video_width", "video_thumbnail_height", "video_thumbnail_width", "video_thumbnail_frames", "video_thumbnail_format"];
  }

  /**
   * Deletegate Keys
   * Creates the arrays for merged solutions 
  */
  delegate_keys(type){
    switch(type) {
      case "idno":
        return [...this.common_keys, ...this.idno_keys]
      case "text":
      case "textarea": 
        return [...this.common_keys, ...this.text_keys]
      case "number":
        return [...this.common_keys, ...this.number_keys]
      case "file":
        return [...this.common_keys, ...this.file_keys]
      case "select":
      case "multiselect":
        return [...this.common_keys, ...this.choice_keys]
      default:
        return this.common_keys
    }
  }

  /**
   * Delete Keys
   * Probably could be a public static variable since all we are doing is returning a set of keys. 
  */
  delete_keys(){ 
    let tmp_obj = {}
    let keys_to_keep = this.delegate_keys(this.type).sort();
    keys_to_keep.forEach(key => tmp_obj[key] = this.obj[key]);
    return tmp_obj; 
  }

}