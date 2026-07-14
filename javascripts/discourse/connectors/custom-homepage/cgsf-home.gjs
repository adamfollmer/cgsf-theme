import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { service } from "@ember/service";
import icon from "discourse/helpers/d-icon";

export default class CgsfHome extends Component {
  @service site;
  @service store;
  @service currentUser;

  @tracked topics = null;

  constructor() {
    super(...arguments);
    this.store
      .findFiltered("topicList", { filter: "latest" })
      .then((list) => {
        this.topics = list.topics
          .filter((t) => !t.pinned)
          .slice(0, 6);
      })
      .catch(() => {
        this.topics = [];
      });
  }

  get firstName() {
    const name = this.currentUser?.name || this.currentUser?.username || "";
    return name.split(" ")[0];
  }

  categoryByName(name) {
    return this.site.categories?.find((c) => c.name === name);
  }

  get cityMeetingsUrl() {
    return this.categoryByName("City Meetings")?.url || "/categories";
  }

  get pollProposalsUrl() {
    return this.categoryByName("Poll Proposals")?.url || "/categories";
  }

  <template>
    <div class="cgsf-home">
      <div class="cgsf-home__hero">
        <h1>Welcome, {{this.firstName}}.</h1>
        <p>
          This is where St. Francis neighbors talk about our city and everyday
          life here — run by residents, independent of city hall.
        </p>
      </div>

      <div class="cgsf-home__buttons">
        <a class="cgsf-home__btn" href="/t/-/5">
          {{icon "book-open"}}
          <span class="cgsf-home__btn-title">New here? Take the tour</span>
          <span class="cgsf-home__btn-sub">Two minutes, everything explained</span>
        </a>
        <a class="cgsf-home__btn" href={{this.cityMeetingsUrl}}>
          {{icon "landmark"}}
          <span class="cgsf-home__btn-title">City Meetings</span>
          <span class="cgsf-home__btn-sub">What the city is working on</span>
        </a>
        <a class="cgsf-home__btn" href={{this.pollProposalsUrl}}>
          {{icon "square-poll-vertical"}}
          <span class="cgsf-home__btn-title">Poll Proposals</span>
          <span class="cgsf-home__btn-sub">Help choose what we ask the town</span>
        </a>
        <a class="cgsf-home__btn" href="/latest">
          {{icon "comments"}}
          <span class="cgsf-home__btn-title">All conversations</span>
          <span class="cgsf-home__btn-sub">Everything happening right now</span>
        </a>
      </div>

      {{#if this.topics.length}}
        <div class="cgsf-home__latest">
          <h2>Happening now</h2>
          <ul>
            {{#each this.topics as |topic|}}
              <li>
                <a href={{topic.url}}>{{topic.title}}</a>
                {{#if topic.category}}
                  <span class="cgsf-home__cat">{{topic.category.name}}</span>
                {{/if}}
              </li>
            {{/each}}
          </ul>
        </div>
      {{/if}}
    </div>
  </template>
}
