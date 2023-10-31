<template>
  <form
      class="form-article-search"
      @submit.prevent="submit"
  >
    <input
        class="form-article-search__input"
        v-model.trim="title"
        type="text"
        :placeholder="$t('HELP_CENTER.HEADER.FORM_SEARCH.ARTICLE_TITLE')"
    />
    <input
        class="form-article-search__input"
        v-model.trim="text"
        type="text"
        :placeholder="$t('HELP_CENTER.HEADER.FORM_SEARCH.ARTICLE_CONTENT')"
    />
    <woot-submit-button
        class="form-article-search__submit"
        :button-text="$t('HELP_CENTER.HEADER.FORM_SEARCH.FIND')"
        type="submit"
        :loading="isLoadingSearch"
        :disabled="isLoadingSearch"
    />
  </form>
</template>

<script>
export default {
  props: {
    isLoadingSearch: {
      type: Boolean,
      default: false,
    },
  },
  data() {
    return {
      title: '',
      text: '',
    };
  },
  methods: {
    submit() {
      this.$emit('submit', { title: this.title, text: this.text });
    },
  },
}
</script>

<style scoped lang="scss">
$b: '.form-article-search';

#{$b} {
  padding: 10px;
  display: flex;
  gap: 8px;

  &__input {
    width: 45%;
    flex: 0 1 auto;
  }

  &__submit {
    width: 10%;
    flex: 0 0 auto;
    justify-content: center;
  }
}
</style>
