<template>
  <search-result-section
    :title="$t('SEARCH.SECTION.CONTACTS')"
    :empty="!contacts.length"
    :query="query"
    :show-title="showTitle"
    :is-fetching="isFetching"
  >
    <ul class="search-list">
      <li v-for="contact in contacts" :key="contact.id">
        <search-result-contact-item
          :id="contact.id"
          :name="contact.name"
          :email="contact.email"
          :phone="contact.phone_number"
          :account-id="accountId"
          :thumbnail="contact.thumbnail"
        />
      </li>
    </ul>
    <woot-button
        v-if="visibleLoadMoreButton"
        type="button"
        :is-disabled="loadingMoreContacts"
        :is-loading="loadingMoreContacts"
        @click="loadMoreContacts"
    >
      {{ $t('SEARCH.LOAD_MORE') }}
    </woot-button>
  </search-result-section>
</template>

<script>
import { mapGetters } from 'vuex';

import SearchResultSection from './SearchResultSection.vue';
import SearchResultContactItem from './SearchResultContactItem.vue';
import WootButton from "../../../components/ui/WootButton";

export default {
  components: {
    SearchResultSection,
    SearchResultContactItem,
    WootButton,
  },
  props: {
    contacts: {
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
    allCountContacts: {
      type: Number,
      default: 0,
    },
    loadingMoreContacts: {
      type: Boolean,
      default: false,
    },
  },
  computed: {
    ...mapGetters({
      accountId: 'getCurrentAccountId',
    }),
    visibleLoadMoreButton() {
      return this.allCountContacts > this.contacts.length;
    },
  },
  methods: {
    loadMoreContacts() {
      this.$emit('load-more', this.contacts.length);
    },
  },
};
</script>
