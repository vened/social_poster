require 'vk-ruby'

module SocialPoster
  module Poster

    class Vkontakte
      include SocialPoster::Helper

      def initialize(options)
        @options = options
        @app = VK::Application.new(access_token: (config_key :access_token))
        @upload_server = @app.photos.getUploadServer(group_id: 95972715, album_id: 216882230)['upload_url']
      end

      def write(text, title)
        #http://fitohoney.ru/uploads/carousel/photo/555785b0766d390dc3540000/carousel________8999.jpg
        photo = @app.upload(
            url: @upload_server,
            file1: ['/Users/max/RubymineProjects/santemax.ru/public/content/1.jpg', 'image/jpeg'],
            file2: ['/Users/max/RubymineProjects/santemax.ru/public/content/2.jpg', 'image/jpeg'],
            file3: ['/Users/max/RubymineProjects/santemax.ru/public/content/3.jpg', 'image/jpeg']
        )
        photos_save = @app.photos.save(
            server: photo.body['server'],
            photos_list: photo.body['photos_list'],
            album_id: photo.body['aid'],
            group_id: photo.body['gid'],
            hash: photo.body['hash']
        ) 
        photos_post = photos_save.map do |item|
          item["id"]
        end
            p photos_post.join(',')
        @app.wall.post({message: text, attachments: "#{photos_post.join(',')},https://github.com/zinenko/vk-ruby#uploading-files"}.merge(@options))
      end
    end

  end
end