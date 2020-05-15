/**
 * Mainly used as a namespace.
 * @param {type} type string. The type distinction is needed for removing un-needed keys
 * @param {hash} object. The json object being worked currently. 
 */
export default class PurgeKeys {
  constructor(type, hash){ 
    this.type = type;
    this.obj = hash;
  }

  common_keys(){ 
    let keys = [ "field_id", "type", "name", "label", "value", "placeholder", "css_id", "css_class", "sort_order", "local_styles", "metadata_standards", "help_type", "help_url", "help_info", "required", "no_duplicates", "read_only", "disabled", "disabled_on_insert", "disabled_on_update", "public_release", "oai_release", "sortable", "searchable", "display_in_list", "hidden", "validation", "validation_regex" ];
    return keys;  
  }

  idno_keys(){ 
    let keys = ['managed_by', 'idno_format', 'start_increment']; 
    return keys; 
  }

  text_keys(){ 
    let keys = ["min", "max", "format"];
    return keys; 
  }

  number_keys(){ 
    let keys = ["step", "min_number", "max_number"];
    return keys; 
  }

  choice_keys(){ 
    let keys = ["choice_type", "default_choice", "choice_array", "choices", "choice_form", "choice_form_field"];
    return keys; 
  }

  file_keys(){ 
    let keys = ["allowed_file_types", "multiple_files", "combine", "ocr", "convert", "thumbnail", "watermark", "border", "convert_audio", "convert_video", "video_thumbnail", "image_height", "image_width", "image_resolution", "image_format", "thumbnail_height", "thumbnail_width", "thumbnail_resolution", "thumbnail_format", "border_height", "border_width", "watermark_image", "watermark_location", "audio_bitrate", "audio_format", "video_bitrate", "video_format", "video_height", "video_width", "video_thumbnail_height", "video_thumbnail_width", "video_thumbnail_frames", "video_thumbnail_format"];
    return keys; 
  }

  delegate_keys(){
    let key_array; 
    let common_keys = this.common_keys(); 
    switch(this.type) {
      case 'idno':
        key_array = common_keys.concat(this.idno_keys());
        break;
      case 'text':
      case 'textarea': 
        key_array = common_keys.concat(this.text_keys());
        break;
      case 'number': 
        key_array = common_keys.concat(this.number_keys()); 
        break;
      case 'file':
        key_array = common_keys.concat(this.file_keys()); 
        break;
      case 'select':
      case 'multiselect':
        key_array = common_keys.concat(this.choice_keys()); 
        break;
      default:
        key_array = common_keys
    }
    return key_array; 
  }

  delete_keys(){ 
    let tmp_obj = this.obj; 
    let keys_to_keep = this.delegate_keys(); 
    for(var key in tmp_obj){ 
      if(!keys_to_keep.includes(key)){ 
        delete tmp_obj[key]; 
      }
    }
    return tmp_obj; 
  }

}