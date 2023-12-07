<template>
  <search-result-section
    :title="$t('SEARCH.SECTION.CONVERSATIONS')"
    :empty="!conversations.length"
    :query="query"
    :show-title="showTitle || isFetching"
    :is-fetching="isFetching"
  >
    <ul class="search-list">
      <li v-for="conversation in conversations" :key="conversation.id">
        <search-result-conversation-item
          :id="conversation.id"
          :name="conversation.contact.name"
          :account-id="accountId"
          :inbox="conversation.inbox"
          :created-at="conversation.created_at"
        />
      </li>
    </ul>
    <woot-button
        v-if="visibleLoadMoreButton"
        type="button"
        :is-disabled="loadingMoreConversations"
        :is-loading="loadingMoreConversations"
        @click="loadMoreConversations"
    >
      {{ $t('SEARCH.LOAD_MORE') }}
    </woot-button>
  </search-result-section>
</template>

<script>
import { mapGetters } from 'vuex';
import SearchResultSection from './SearchResultSection.vue';
import SearchResultConversationItem from './SearchResultConversationItem.vue';
import WootButton from "../../../components/ui/WootButton";

export default {
  components: {
    SearchResultSection,
    SearchResultConversationItem,
    WootButton,
  },
  props: {
    conversations: {
      type: Array,
      default: () => [],
    },
    query: {
      type: String,
      default: '',
    },
    isFetching: {
      type: Boolean,
      default: false,
    },
    showTitle: {
      type: Boolean,
      default: true,
    },
    allCountConversations: {
      type: Number,
      default: 0,
    },
    loadingMoreConversations: {
      type: Boolean,
      default: false,
    },
  },
  computed: {
    ...mapGetters({
      accountId: 'getCurrentAccountId',
    }),
    visibleLoadMoreButton() {
      return this.allCountConversations > this.conversations.length;
    },
  },
  methods: {
    loadMoreConversations() {
      this.$emit('load-more', this.conversations.length);
    },
  },
};
</script>
