module Conversion::Params
  def image_param_keys
    %w[border border_width combine conver disabled image_format image_height image_resolution image_width ocr thumbnail thumbnail_format thumbnail_height thumbnail_resolution thumbnail_width watermark watermark_image watermark_location]
  end 

  def video_param_keys
    %w[convert_video video_bitrate video_format video_height video_thumbnail video_thumbnail_format video_thumbnail_frames video_thumbnail_height video_thumbnail_width video_width]
  end 

  def audio_param_keys
    %w[audio_bitrate audio_format conver_audio]
  end 
end