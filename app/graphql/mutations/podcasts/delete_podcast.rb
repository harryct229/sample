# frozen_string_literal: true

module Mutations
  module Podcasts
    class DeletePodcast < Mutations::BaseMutation
      description 'Deletes a podcast as an owner.'
      argument :id, ID, required: true
      
      field :errors, [::Types::Auth::Error], null: false
      field :success, Boolean, null: false
      field :podcast, Types::Podcasts::PodcastType, null: true

      def resolve(id:)
        podcast = ::Podcast.accessible_by(current_ability).find_by(id: id)
        if podcast.nil?
          raise ActiveRecord::RecordNotFound,
                I18n.t('errors.messages.resource_not_found', resource: ::Podcast.model_name.human)
        end

        current_ability.authorize! :destroy, podcast
        podcast.destroy

        # TODO: Delete related conversations
        # class McPodcastView(APIView):
        #   def delete(self, request,):
        #       try:
        #           token = token_utils.is_request_valid(request)
        #           if not token:
        #               return Response(
        #                   {"error": "Unauthorized!"}, 
        #                   status=status.HTTP_401_UNAUTHORIZED
        #               )

        #           user_id = token["user_id"]
        #           mc_podcast_id = request.query_params.get("mc_podcast_id")

        #           mc_podcast = McPodcastInfo.objects.get(
        #               user_id = user_id,
        #               podcast_id = mc_podcast_id, 
        #           )

        #           mc_conversations = McConversation.objects.filter(
        #               podcast_id=mc_podcast.referred_podcast_id,
        #               mc_podcaster_user_id=user_id,
        #           )

        #           mc_podcast.delete()

        #           for mc_conversation in mc_conversations:
        #               conversation_sid = mc_conversation.conversation_sid
        #               if conversation_sid:
        #                   # client.conversations.conversations(conversation_sid).delete()
        #                   conversation = client.conversations.conversations(conversation_sid).fetch()
        #                   participants = client.conversations.conversations(conversation_sid).participants.list(limit=5)

        #                   for participant in participants:
        #                       if participant.identity == user_id:
        #                           client.conversations.conversations(conversation_sid).participants(participant.sid).delete()

        #                   attributes = json.loads(conversation.attributes)
        #                   attributes["is_disabled"] = 1

        #                   conversation = client.conversations.conversations(conversation_sid).update(
        #                       unique_name="%s__disabled__%s" % (conversation.unique_name, mc_podcast_id),
        #                       attributes=json.dumps(attributes)
        #                   )

        #                   message = client.conversations.conversations(conversation_sid).messages.create(author=None, body='Podcaster left this conversation. This conversation will be archived!')
        #               mc_conversation.delete()


        #           # client = Client(settings.TWILIO_ACCOUNT_SID, settings.TWILIO_AUTH_TOKEN)

        #           # conversation = client.conversations.conversations(conversation_sid).fetch()

        #           # attributes = json.loads(conversation.attributes)
        #           # attributes["is_archived"] = 1

        #           # conversation = client.conversations.conversations(conversation_sid).update(
        #           #     attributes=json.dumps(attributes)
        #           # )

        #           return Response({
        #               "mc_podcast": mc_podcast_id,
        #           }) 
        #       except Exception as e:
        #           print(e)
        #           return Response(
        #               {"error": "Unauthorized!"}, 
        #               status=status.HTTP_401_UNAUTHORIZED
        #           )

        {
          errors: podcast.errors.messages.map do |field, messages|
            { 
              field: field.to_s.camelize(:lower),
              message: podcast.errors.full_message(field, messages.first),
            }
          end,
          success: podcast.destroyed?,
          podcast: podcast
        }
      end
    end
  end
end
