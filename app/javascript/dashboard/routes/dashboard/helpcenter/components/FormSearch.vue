<template>
  <form
      class="form-article-search"
      @submit.prevent="submit"
  >
    <input
        class="form-article-search__input"
        v-model.trim="title"
        type="text"
        :placeholder="$t('HELP_CENTER.FORM_SEARCH.PLACEHOLDER_TITLE_INPUT')"
    />
    <input
        class="form-article-search__input"
        v-model.trim="text"
        type="text"
        :placeholder="$t('HELP_CENTER.FORM_SEARCH.PLACEHOLDER_TEXT_INPUT')"
    />
    <woot-submit-button
        class="form-article-search__submit"
        :button-text="$t('HELP_CENTER.FORM_SEARCH.SEARCH_BUTTON')"
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
    width: 40%;
    flex: 1 1 auto;
  }

  &__submit {
    max-width: 20%;
    flex: 0 0 auto;
    justify-content: center;
  }
}
</style>
