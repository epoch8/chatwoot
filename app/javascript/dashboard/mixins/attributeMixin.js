import { mapGetters } from 'vuex';
import { isValidURL } from '../helper/URLHelper';
export default {
  computed: {
    ...mapGetters({
      currentChat: 'getSelectedChat',
      accountId: 'getCurrentAccountId',
    }),
    attributes() {
      return this.$store.getters['attributes/getAttributesByModel'](
        this.attributeType
      );
    },
    customAttributes() {
      if (this.attributeType === 'conversation_attribute')
        return this.currentChat.custom_attributes || {};
      return this.contact.custom_attributes || {};
    },
    contactIdentifier() {
      return (
        this.currentChat.meta?.sender?.id ||
        this.$route.params.contactId ||
        this.contactId
      );
    },
    contact() {
      return this.$store.getters['contacts/getContact'](this.contactIdentifier);
    },
    conversationId() {
      return this.currentChat.id;
    },

    filteredAttributes() {
      const attribute_names = [
        ...new Set([
          ...Object.keys(this.customAttributes),
          ...this.attributes
            .filter(attribute => attribute.meta && attribute.meta.required)
            .map(attribute => attribute.attribute_key),
        ]),
      ];

      return attribute_names.map(key => {
        const item = this.attributes.find(
          attribute => attribute.attribute_key === key
        );
        if (item) {
          return {
            ...item,
            value: this.customAttributes[key],
            selectValues: this.attributeSelectValues(item),
          };
        }

        return {
          ...item,
          value: this.customAttributes[key],
          attribute_description: key,
          attribute_display_name: key,
          attribute_display_type: this.attributeDisplayType(
            this.customAttributes[key]
          ),
          attribute_key: key,
          attribute_model: this.attributeType,
          selectValues: null,
          id: Math.random(),
        };
      });
    },
  },
  methods: {
    isAttributeNumber(attributeValue) {
      return (
        Number.isInteger(Number(attributeValue)) && Number(attributeValue) > 0
      );
    },
    attributeDisplayType(attributeValue) {
      if (this.isAttributeNumber(attributeValue)) {
        return 'number';
      }
      if (isValidURL(attributeValue)) {
        return 'link';
      }
      return 'text';
    },
    attributeSelectValues(attribute) {
      if (attribute.meta && attribute.meta.select_values) {
        return attribute.meta.select_values;
      }
      return null;
    },
  },
};
