<template>
  <form
      class="form-article-search"
      @submit.prevent="submit"
  >
    <woot-input
        class="form-article-search__input"
        v-model.trim="title"
        type="text"
        placeholder="Введите заголовок статьи"
    />
    <woot-input
        class="form-article-search__input"
        v-model.trim="text"
        type="text"
        placeholder="Введите текст статьи"
    />
    <woot-submit-button
        class="form-article-search__submit"
        button-text="Найти"
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
