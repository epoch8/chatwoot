<template>
<button
    type="button"
    class="button-sort-article"
    :class="{
          'button-sort-article--active-asc': ascSortStatus,
          'button-sort-article--active-desc': descSortStatus,
          'button-sort-article--disable': disabled,
        }"
    @click="click"
>
  <slot />
  <span class="button-sort-article__icon-sort">
    <fluent-icon icon="caret-up" size="12px" class="caret-up-icon" />
    <fluent-icon icon="caret-down" size="12px" class="caret-down-icon" />
  </span>
</button>
</template>

<script>
import FluentIcon from 'shared/components/FluentIcon/DashboardIcon';

export default {
  name: "buttonSortArticles",
  components: {
    FluentIcon,
  },
  props: {
    active: {
      type: Boolean,
      default: false,
    },
    disabled: {
      type: Boolean,
      default: false,
    },
  },
  watch: {
    active(newValue) {
      if (!newValue) {
        this.ascSort = true;
      }
    },
  },
  computed: {
    ascSortStatus() {
      return this.active && this.ascSort;
    },
    descSortStatus() {
      return this.active && !this.ascSort;
    },
  },
  data() {
    return {
      ascSort: true,
    };
  },
  methods: {
    click() {
      if (this.active) {
        this.ascSort = !this.ascSort;
      }
      this.$emit('click', this.ascSort);
    },
  },
}
</script>

<style lang="scss" scoped>
$b: '.button-sort-article';

#{$b} {
  min-width: 24px;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 1px;
  padding: 1px;

  &__icon-sort {
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    color: var(--s-700);
    min-width: 8px;
  }

  &--active-asc {
    & svg:first-child {
      color: var(--color-woot);
    }
  }

  &--active-desc {
    & svg:last-child {
      color: var(--color-woot);
    }
  }

  &--disable {
    pointer-events: none;
    opacity: 0.6;
  }
}
</style>
