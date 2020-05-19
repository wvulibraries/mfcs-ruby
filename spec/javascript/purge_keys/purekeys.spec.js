import PurgeKeys from "form_builder/purge_keys.js";

  const json_test = {
    "field_id":"3589821000001393",
    "type":"idno",
    "name":"idno",
    "label":"Identifier",
    "value":"",
    "placeholder":"",
    "css_id":"sdfklhjadsff ",
    "css_class":"as;dflkjasdf asdfl;kjasd ",
    "sort_order":"1",
    "local_styles":"",
    "metadata_standards":"test",
    "schema":"Dublin Core",
    "identifier":"id",
    "qualifier":"qualifier",
    "help_type":"",
    "help_url":"",
    "help_info":"",
    "managed_by":"System",
    "idno_format":"test_#####",
    "start_increment":"1",
    "min":"1",
    "max":"10000",
    "format":"test",
    "step":"1",
    "min_number":"1",
    "max_number":"100000",
    "choice_type":"",
    "default_choice":"",
    "choice_array":"",
    "choices":"",
    "choice_form":"",
    "choice_form_field":"",
    "allowed_file_types":"",
    "extension":"",
    "multiple_files":false,
    "combine":false,
    "ocr":false,
    "convert":false,
    "thumbnail":false,
    "watermark":false,
    "border":false,
    "convert_audio":false,
    "convert_video":false,
    "video_thumbnail":false,
    "image_height":"",
    "image_width":"",
    "image_resolution":"",
    "image_format":"",
    "thumbnail_height":"",
    "thumbnail_width":"",
    "thumbnail_resolution":"",
    "thumbnail_format":"",
    "border_height":"",
    "border_width":"",
    "watermark_image":"",
    "watermark_location":"",
    "audio_bitrate":"",
    "audio_format":"",
    "video_bitrate":"",
    "video_format":"",
    "video_height":"",
    "video_width":"",
    "video_thumbnail_height":"",
    "video_thumbnail_width":"",
    "video_thumbnail_frames":"",
    "video_thumbnail_format":"",
    "required":true,
    "no_duplicates":false,
    "read_only":false,
    "disabled":false,
    "disabled_on_insert":false,
    "disabled_on_update":false,
    "public_release":true,
    "oai_release":true,
    "sortable":true,
    "searchable":true,
    "display_in_list":true,
    "hidden":false,
    "validation":"",
    "validation_regex":""
  }

/**
 * IDNO Test
 * ============================================================================
*/
describe("IDNO", ()=> { 
  let expectedkeys = [ "field_id", "type", "name", "label", "value", "placeholder", "css_id", "css_class", "sort_order", "local_styles", "metadata_standards", "help_type", "help_url", "help_info", "required", "no_duplicates", "read_only", "disabled", "disabled_on_insert", "disabled_on_update", "public_release", "oai_release", "sortable", "searchable", "display_in_list", "hidden", "validation", "validation_regex", 'managed_by', 'idno_format', 'start_increment']; 
  let purge = new PurgeKeys('idno', json_test); 
  let purgeIdnoDel = purge.delegate_keys('idno'); 
  
  it('deletes and ruturns the proper expected keys', () => {
    let idno_tmp_keys = Object.keys(purge.delete_keys());
    expect(idno_tmp_keys.length).toEqual(expectedkeys.length); 
    expect(idno_tmp_keys.sort()).toEqual(expectedkeys.sort()); 
  });

  it('has same delegated keys as expected keys', () => {
    expect(purgeIdnoDel.sort()).toEqual(expectedkeys.sort());
  });

  it('has same number of delegated keys as expected keys', () => {
    expect(purgeIdnoDel.length).toEqual(expectedkeys.length);
  });
});

/**
 * Text Keys
 * ============================================================================
*/
describe("Text", ()=> { 
  let textExpectKeys = [ "field_id", "type", "name", "label", "value", "placeholder", "css_id", "css_class", "sort_order", "local_styles", "metadata_standards", "help_type", "help_url", "help_info", "required", "no_duplicates", "read_only", "disabled", "disabled_on_insert", "disabled_on_update", "public_release", "oai_release", "sortable", "searchable", "display_in_list", "hidden", "validation", "validation_regex", "min", "max", "format"]; 
  let purgeText = new PurgeKeys('text', json_test); 
  let purgeTextDel = purgeText.delegate_keys('text');

  it('deletes and ruturns the proper expected keys', () => {
    let txt_tmp_keys = Object.keys(purgeText.delete_keys());
    expect(txt_tmp_keys.length).toEqual(textExpectKeys.length); 
    expect(txt_tmp_keys.sort()).toEqual(textExpectKeys.sort()); 
  });

  it('has same delegated keys as expected keys', () => {
    expect(purgeTextDel.sort()).toEqual(textExpectKeys.sort());
  });

  it('has same number of delegated keys as expected keys', () => {
    expect(purgeTextDel.length).toEqual(textExpectKeys.length);
  });
});

/**
 * Number Keys
 * ============================================================================
*/
describe("Number", ()=> { 
  let numKeys = [ "field_id", "type", "name", "label", "value", "placeholder", "css_id", "css_class", "sort_order", "local_styles", "metadata_standards", "help_type", "help_url", "help_info", "required", "no_duplicates", "read_only", "disabled", "disabled_on_insert", "disabled_on_update", "public_release", "oai_release", "sortable", "searchable", "display_in_list", "hidden", "validation", "validation_regex", "step", "min_number", "max_number"]; 
  let purgeNum = new PurgeKeys('number', json_test); 
  let purgeNumDel = purgeNum.delegate_keys('number'); 

  it('deletes and ruturns the proper expected keys', () => {
    let num_tmp_keys = Object.keys(purgeNum.delete_keys());
    expect(num_tmp_keys.length).toEqual(numKeys.length); 
    expect(num_tmp_keys.sort()).toEqual(numKeys.sort()); 
  });

  it('has same delegated keys as expected keys', () => {
    expect(purgeNumDel.sort()).toEqual(numKeys.sort());
  });

  it('has same number of delegated keys as expected keys', () => {
    expect(purgeNumDel.length).toEqual(numKeys.length);
  });
});

/**
 * File
 * ============================================================================
*/
describe("File", ()=> { 
  let fileKeys = [ "field_id", "type", "name", "label", "value", "placeholder", "css_id", "css_class", "sort_order", "local_styles", "metadata_standards", "help_type", "help_url", "help_info", "required", "no_duplicates", "read_only", "disabled", "disabled_on_insert", "disabled_on_update", "public_release", "oai_release", "sortable", "searchable", "display_in_list", "hidden", "validation", "validation_regex", "allowed_file_types", "multiple_files", "combine", "ocr", "convert", "thumbnail", "watermark", "border", "convert_audio", "convert_video", "video_thumbnail", "image_height", "image_width", "image_resolution", "image_format", "thumbnail_height", "thumbnail_width", "thumbnail_resolution", "thumbnail_format", "border_height", "border_width", "watermark_image", "watermark_location", "audio_bitrate", "audio_format", "video_bitrate", "video_format", "video_height", "video_width", "video_thumbnail_height", "video_thumbnail_width", "video_thumbnail_frames", "video_thumbnail_format"]; 
  let purgeFile = new PurgeKeys('file', json_test); 
  let purgeFileDel = purgeFile.delegate_keys('file'); 

  it('deletes and ruturns the proper expected keys', () => {
    let file_tmp_keys = Object.keys(purgeFile.delete_keys());
    expect(file_tmp_keys.length).toEqual(fileKeys.length); 
    expect(file_tmp_keys.sort()).toEqual(fileKeys.sort()); 
  });

  it('has same delegated keys as expected keys', () => {
    expect(purgeFileDel.sort()).toEqual(fileKeys.sort());
  });

  it('has same number of delegated keys as expected keys', () => {
    expect(purgeFileDel.length).toEqual(fileKeys.length);
  });
});

/**
 * Select
 * ============================================================================
*/
describe("Select", ()=> { 
  let selectKeys = ["field_id", "type", "name", "label", "value", "placeholder", "css_id", "css_class", "sort_order", "local_styles", "metadata_standards", "help_type", "help_url", "help_info", "required", "no_duplicates", "read_only", "disabled", "disabled_on_insert", "disabled_on_update", "public_release", "oai_release", "sortable", "searchable", "display_in_list", "hidden", "validation", "validation_regex", "choice_type", "default_choice", "choice_array", "choices", "choice_form", "choice_form_field"]; 
  let purgeSelect = new PurgeKeys('select', json_test); 
  let purgeSelectDel = purgeSelect.delegate_keys('select'); 

  it('deletes and ruturns the proper expected keys', () => {
    let sel_tmp_keys = Object.keys(purgeSelect.delete_keys());
    expect(sel_tmp_keys.length).toEqual(selectKeys.length); 
    expect(sel_tmp_keys.sort()).toEqual(selectKeys.sort()); 
  }); 

  it('has same delegated keys as expected keys', () => {
    expect(purgeSelectDel.sort()).toEqual(selectKeys.sort());
  });

  it('has same number of delegated keys as expected keys', () => {
    expect(purgeSelectDel.length).toEqual(selectKeys.length);
  });
});

/**
 * Multiselect
 * ============================================================================
*/
describe("Multiselect", ()=> { 
  let multiselectKeys = ["field_id", "type", "name", "label", "value", "placeholder", "css_id", "css_class", "sort_order", "local_styles", "metadata_standards", "help_type", "help_url", "help_info", "required", "no_duplicates", "read_only", "disabled", "disabled_on_insert", "disabled_on_update", "public_release", "oai_release", "sortable", "searchable", "display_in_list", "hidden", "validation", "validation_regex", "choice_type", "default_choice", "choice_array", "choices", "choice_form", "choice_form_field"]; 
  let purgeMultiselect = new PurgeKeys('multiselect', json_test); 
  let purgeMultiselectDel = purgeMultiselect.delegate_keys('multiselect');

  it('deletes and ruturns the proper expected keys', () => {
    let ms_tmp_keys = Object.keys(purgeMultiselect.delete_keys());
    expect(ms_tmp_keys.length).toEqual(multiselectKeys.length); 
    expect(ms_tmp_keys.sort()).toEqual(multiselectKeys.sort()); 
  }); 

  it('has same delegated keys as expected keys', () => {
    expect(purgeMultiselectDel.sort()).toEqual(multiselectKeys.sort());
  });

  it('has same number of delegated keys as expected keys', () => {
    expect(purgeMultiselectDel.length).toEqual(multiselectKeys.length);
  });
});

/**
 * Common No Type
 * ============================================================================
*/
describe("Common No Type Given", ()=> { 
  let commonKeys = ["field_id", "type", "name", "label", "value", "placeholder", "css_id", "css_class", "sort_order", "local_styles", "metadata_standards", "help_type", "help_url", "help_info", "required", "no_duplicates", "read_only", "disabled", "disabled_on_insert", "disabled_on_update", "public_release", "oai_release", "sortable", "searchable", "display_in_list", "hidden", "validation", "validation_regex"]; 
  let purgeCommon = new PurgeKeys('', json_test); 
  let purgeCommonDel = purgeCommon.delegate_keys(''); 

  it('deletes and ruturns the proper expected keys', () => {
    let common_tmp_keys = Object.keys(purgeCommon.delete_keys());
    expect(common_tmp_keys.length).toEqual(commonKeys.length); 
    expect(common_tmp_keys.sort()).toEqual(commonKeys.sort()); 
  }); 

  it('has same delegated keys as expected keys', () => {
    expect(purgeCommonDel.sort()).toEqual(commonKeys.sort());
  });

  it('has same number of delegated keys as expected keys', () => {
    expect(purgeCommonDel.length).toEqual(commonKeys.length);
  });
});