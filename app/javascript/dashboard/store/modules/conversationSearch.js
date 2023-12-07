import SearchAPI from '../../api/search';
import types from '../mutation-types';
export const initialState = {
  records: [],
  contactRecords: [],
  conversationRecords: [],
  messageRecords: [],
  countMessageRecords: 0,
  countConversationRecords: 0,
  countContactRecords: 0,
  uiFlags: {
    isFetching: false,
    isSearchCompleted: false,
    contact: { isFetching: false },
    conversation: { isFetching: false },
    message: { isFetching: false },
  },
};

export const getters = {
  getConversations(state) {
    return state.records;
  },
  getContactRecords(state) {
    return state.contactRecords;
  },
  getConversationRecords(state) {
    return state.conversationRecords;
  },
  getMessageRecords(state) {
    return state.messageRecords;
  },
  getUIFlags(state) {
    return state.uiFlags;
  },
  getCountContactRecords(state) {
    return state.countContactRecords;
  },
  getCountConversationRecords(state) {
    return state.countConversationRecords;
  },
  getCountMessageRecords(state) {
    return state.countMessageRecords;
  },
};

export const actions = {
  async get({ commit }, { q }) {
    commit(types.SEARCH_CONVERSATIONS_SET, []);
    if (!q) {
      return;
    }
    commit(types.SEARCH_CONVERSATIONS_SET_UI_FLAG, { isFetching: true });
    try {
      const {
        data: { payload },
      } = await SearchAPI.get({ q });
      commit(types.SEARCH_CONVERSATIONS_SET, payload);
    } catch (error) {
      // Ignore error
    } finally {
      commit(types.SEARCH_CONVERSATIONS_SET_UI_FLAG, {
        isFetching: false,
      });
    }
  },
  async fullSearch({ commit, dispatch }, { q, offset }) {
    if (!q) {
      return;
    }
    commit(types.FULL_SEARCH_SET_UI_FLAG, {
      isFetching: true,
      isSearchCompleted: false,
    });
    try {
      await Promise.all([
        dispatch('contactSearch', { q, offset }),
        dispatch('conversationSearch', { q, offset }),
        dispatch('messageSearch', { q, offset }),
      ]);
    } catch (error) {
      // Ignore error
    } finally {
      commit(types.FULL_SEARCH_SET_UI_FLAG, {
        isFetching: false,
        isSearchCompleted: true,
      });
    }
  },
  async contactSearch({ commit, state }, { q, offset }) {
    commit(types.CONTACT_SEARCH_SET_UI_FLAG, { isFetching: true });
    try {
      const { data } = await SearchAPI.contacts({ q, offset });
      let dataArray = null;
      if (state.contactRecords.length > 0) {
        dataArray = state.contactRecords.concat(data.payload.contacts);
      } else {
        dataArray = data.payload.contacts;
      }
      commit(types.CONTACT_SEARCH_COUNT_SET, data.payload.countAllRecords);
      commit(types.CONTACT_SEARCH_SET, dataArray);
    } catch (error) {
      // Ignore error
    } finally {
      commit(types.CONTACT_SEARCH_SET_UI_FLAG, { isFetching: false });
    }
  },
  async conversationSearch({ commit, state }, { q, offset }) {
    commit(types.CONVERSATION_SEARCH_SET_UI_FLAG, { isFetching: true });
    try {
      const { data } = await SearchAPI.conversations({ q, offset });
      let dataArray = null;
      if (state.conversationRecords.length > 0) {
        dataArray = state.conversationRecords.concat(data.payload.conversations);
      } else {
        dataArray = data.payload.conversations;
      }
      commit(types.CONVERSATION_SEARCH_COUNT_SET, data.payload.countAllRecords);
      commit(types.CONVERSATION_SEARCH_SET, dataArray);
    } catch (error) {
      // Ignore error
    } finally {
      commit(types.CONVERSATION_SEARCH_SET_UI_FLAG, { isFetching: false });
    }
  },
  async messageSearch({ commit, state }, { q, offset }) {
    commit(types.MESSAGE_SEARCH_SET_UI_FLAG, { isFetching: true });
    try {
      const { data } = await SearchAPI.messages({ q, offset });
      let dataArray = null;
      if (state.messageRecords.length > 0) {
        dataArray = state.messageRecords.concat(data.payload.messages);
      } else {
        dataArray = data.payload.messages;
      }
      commit(types.MESSAGE_SEARCH_COUNT_SET, data.payload.countAllRecords);
      commit(types.MESSAGE_SEARCH_SET, dataArray);
    } catch (error) {
      // Ignore error
    } finally {
      commit(types.MESSAGE_SEARCH_SET_UI_FLAG, { isFetching: false });
    }
  },
  async clearSearchResults({ commit }) {
    commit(types.MESSAGE_SEARCH_SET, []);
    commit(types.CONVERSATION_SEARCH_SET, []);
    commit(types.CONTACT_SEARCH_SET, []);
    commit(types.MESSAGE_SEARCH_COUNT_SET, 0);
    commit(types.CONVERSATION_SEARCH_COUNT_SET, 0);
    commit(types.CONTACT_SEARCH_COUNT_SET, 0);
  },
};

export const mutations = {
  [types.SEARCH_CONVERSATIONS_SET](state, records) {
    state.records = records;
  },
  [types.CONTACT_SEARCH_SET](state, records) {
    state.contactRecords = records;
  },
  [types.CONVERSATION_SEARCH_SET](state, records) {
    state.conversationRecords = records;
  },
  [types.MESSAGE_SEARCH_SET](state, records) {
    state.messageRecords = records;
  },
  [types.SEARCH_CONVERSATIONS_SET_UI_FLAG](state, uiFlags) {
    state.uiFlags = { ...state.uiFlags, ...uiFlags };
  },
  [types.FULL_SEARCH_SET_UI_FLAG](state, uiFlags) {
    state.uiFlags = { ...state.uiFlags, ...uiFlags };
  },
  [types.CONTACT_SEARCH_SET_UI_FLAG](state, uiFlags) {
    state.uiFlags.contact = { ...state.uiFlags.contact, ...uiFlags };
  },
  [types.CONVERSATION_SEARCH_SET_UI_FLAG](state, uiFlags) {
    state.uiFlags.conversation = { ...state.uiFlags.conversation, ...uiFlags };
  },
  [types.MESSAGE_SEARCH_SET_UI_FLAG](state, uiFlags) {
    state.uiFlags.message = { ...state.uiFlags.message, ...uiFlags };
  },
  [types.CONTACT_SEARCH_COUNT_SET](state, records) {
    state.countContactRecords = records;
  },
  [types.CONVERSATION_SEARCH_COUNT_SET](state, records) {
    state.countConversationRecords = records;
  },
  [types.MESSAGE_SEARCH_COUNT_SET](state, records) {
    state.countMessageRecords = records;
  },
};

export default {
  namespaced: true,
  state: initialState,
  getters,
  actions,
  mutations,
};
