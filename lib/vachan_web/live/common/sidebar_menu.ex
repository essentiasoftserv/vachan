defmodule VachanWeb.Common.Icons do
  use VachanWeb, :live_component

  def people(assigns) do
    ~H"""
    <svg
      class="w-5 h-5 text-gray-500 dark:text-gray-400"
      fill="currentColor"
      version="1.1"
      xmlns="http://www.w3.org/2000/svg"
      viewBox="144 144 512 512"
    >
      <path d="m400 279.29c-13.922 0-27.27-5.5273-37.109-15.371-9.8438-9.8398-15.371-23.188-15.371-37.109 0-13.918 5.5273-27.266 15.371-37.109 9.8398-9.8398 23.188-15.371 37.109-15.371 13.918 0 27.266 5.5312 37.109 15.371 9.8398 9.8438 15.371 23.191 15.371 37.109 0 13.922-5.5312 27.27-15.371 37.109-9.8438 9.8438-23.191 15.371-37.109 15.371zm-125.95 94.465v83.969c0 7.5 4 14.43 10.496 18.18 6.4961 3.75 14.496 3.75 20.992 0 6.4922-3.75 10.496-10.68 10.496-18.18v-83.969c0.003906-5.5664 2.2148-10.902 6.1523-14.84 3.9336-3.9336 9.2734-6.1484 14.84-6.1523v251.91c0 7.5 4 14.43 10.496 18.18 6.4922 3.75 14.496 3.75 20.992 0 6.4922-3.75 10.496-10.68 10.496-18.18v-125.95h41.984v125.95c0 7.5 4 14.43 10.496 18.18 6.4922 3.75 14.496 3.75 20.992 0 6.4922-3.75 10.496-10.68 10.496-18.18v-251.91c5.5664 0.003906 10.902 2.2188 14.84 6.1523 3.9336 3.9375 6.1484 9.2734 6.1484 14.84v83.969c0 7.5 4.0039 14.43 10.496 18.18 6.4961 3.75 14.5 3.75 20.992 0 6.4961-3.75 10.496-10.68 10.496-18.18v-83.969c-0.015625-16.695-6.6562-32.703-18.465-44.512-11.805-11.805-27.812-18.445-44.508-18.465h-125.95c-16.699 0.019531-32.707 6.6602-44.512 18.465-11.805 11.809-18.445 27.816-18.465 44.512z">
      </path>
    </svg>
    """
  end
end

defmodule VachanWeb.SidebarMenuLiveComponent do
  use VachanWeb, :live_component

  slot :inner_block, required: true
  attr :path, :string
  attr :label, :string

  def menu_item(assigns) do
    ~H"""
    <.link
      navigate={@path}
      class="flex items-center p-2 text-gray-900 rounded-lg dark:text-white hover:bg-customBackground_header dark:hover:bg-gray-700 group"
    >
      <%= render_slot(@inner_block) %>
      <span class="ml-3">
        <%= @label %>
      </span>
    </.link>
    """
  end

  def render(assigns) do
    ~H"""
    <div
      id="drawer-navigation"
      class="fixed top-0 left-0 z-40 h-screen overflow-y-auto transition-transform bg-customBackground w-60 dark:bg-gray-800 -translate-x-full"
      tabindex="-1"
      aria-labelledby="drawer-navigation-label"
      aria-modal="true"
      role="dialog"
    >
      <div class=" border-b border-gray-300">
        <img src="/images/vaak-logo.svg" class="mrw-3 h-14 w-fusll" alt="Vaak Logo" />
      </div>
      <button
        type="button"
        data-drawer-hide="drawer-navigation"
        aria-controls="drawer-navigation"
        class="text-gray-400 bg-transparent hover:bg-gray-200 hover:text-gray-900 rounded-lg text-sm w-8 h-8 absolute top-2.5 end-2.5 inline-flex items-center justify-center dark:hover:bg-gray-600 dark:hover:text-white"
      >
        <svg
          class="w-3 h-3"
          aria-hidden="true"
          xmlns="http://www.w3.org/2000/svg"
          fill="none"
          viewBox="0 0 14 14"
        >
          <path
            stroke="currentColor"
            stroke-linecap="round"
            stroke-linejoin="round"
            stroke-width="2"
            d="m1 1 6 6m0 0 6 6M7 7l6-6M7 7l-6 6"
          >
          </path>
        </svg>
        <span class="sr-only">Close menu</span>
      </button>
      <div class="py-4 overflow-y-auto"></div>
      <ul class="space-y-2 font-medium">
        <li>
          <.menu_item label="People" path={~p"/people"}>
            <VachanWeb.Common.Icons.people />
          </.menu_item>
        </li>
        <li>
          <.menu_item label="Lists" path={~p"/lists"}>
            <svg
              aria-hidden="true"
              class="w-6 h-6 text-gray-500 transition duration-75 dark:text-gray-400 group-hover:text-gray-900 dark:group-hover:text-white"
              fill="currentColor"
              viewBox="0 0 20 20"
              xmlns="http://www.w3.org/2000/svg"
            >
              <path d="M2 10a8 8 0 018-8v8h8a8 8 0 11-16 0z"></path>
              <path d="M12 2.252A8.014 8.014 0 0117.748 8H12V2.252z"></path>
            </svg>
          </.menu_item>
        </li>
        <li>
          <.menu_item label="Sender Profiles" path={~p"/sender-profiles"}>
            <svg
              aria-hidden="true"
              class="w-6 h-6 text-gray-500 transition duration-75 dark:text-gray-400 group-hover:text-gray-900 dark:group-hover:text-white"
              fill="currentColor"
              viewBox="0 0 20 20"
              xmlns="http://www.w3.org/2000/svg"
            >
              <path d="M2 10a8 8 0 018-8v8h8a8 8 0 11-16 0z"></path>
              <path d="M12 2.252A8.014 8.014 0 0117.748 8H12V2.252z"></path>
            </svg>
          </.menu_item>
        </li>
        <li>
          <.menu_item label="Campaigns" path={~p"/campaigns"}>
            <svg
              aria-hidden="true"
              class="w-6 h-6 text-gray-500 transition duration-75 dark:text-gray-400 group-hover:text-gray-900 dark:group-hover:text-white"
              fill="currentColor"
              viewBox="0 0 20 20"
              xmlns="http://www.w3.org/2000/svg"
            >
              <path d="M2 10a8 8 0 018-8v8h8a8 8 0 11-16 0z"></path>
              <path d="M12 2.252A8.014 8.014 0 0117.748 8H12V2.252z"></path>
            </svg>
          </.menu_item>
        </li>
      </ul>

      <div class="hidden absolute bottom-0 left-0 justify-center p-4 space-x-4 w-full lg:flex bg-customBackground dark:bg-gray-800 z-20">
        <a
          href="#"
          class="inline-flex justify-center p-2 text-gray-500 rounded cursor-pointer dark:text-gray-400 hover:text-gray-900 dark:hover:text-white hover:bg-customBackground_header dark:hover:bg-gray-600"
        >
          <svg
            aria-hidden="true"
            class="w-6 h-6"
            fill="currentColor"
            viewBox="0 0 20 20"
            xmlns="http://www.w3.org/2000/svg"
          >
            <path d="M5 4a1 1 0 00-2 0v7.268a2 2 0 000 3.464V16a1 1 0 102 0v-1.268a2 2 0 000-3.464V4zM11 4a1 1 0 10-2 0v1.268a2 2 0 000 3.464V16a1 1 0 102 0V8.732a2 2 0 000-3.464V4zM16 3a1 1 0 011 1v7.268a2 2 0 010 3.464V16a1 1 0 11-2 0v-1.268a2 2 0 010-3.464V4a1 1 0 011-1z">
            </path>
          </svg>
        </a>
        <a
          href="#"
          data-tooltip-target="tooltip-settings"
          class="inline-flex justify-center p-2 text-gray-500 rounded cursor-pointer dark:text-gray-400 dark:hover:text-white hover:text-gray-900 hover:bg-customBackground_header dark:hover:bg-gray-600"
        >
          <svg
            aria-hidden="true"
            class="w-6 h-6"
            fill="currentColor"
            viewBox="0 0 20 20"
            xmlns="http://www.w3.org/2000/svg"
          >
            <path
              fill-rule="evenodd"
              d="M11.49 3.17c-.38-1.56-2.6-1.56-2.98 0a1.532 1.532 0 01-2.286.948c-1.372-.836-2.942.734-2.106 2.106.54.886.061 2.042-.947 2.287-1.561.379-1.561 2.6 0 2.978a1.532 1.532 0 01.947 2.287c-.836 1.372.734 2.942 2.106 2.106a1.532 1.532 0 012.287.947c.379 1.561 2.6 1.561 2.978 0a1.533 1.533 0 012.287-.947c1.372.836 2.942-.734 2.106-2.106a1.533 1.533 0 01.947-2.287c1.561-.379 1.561-2.6 0-2.978a1.532 1.532 0 01-.947-2.287c.836-1.372-.734-2.942-2.106-2.106a1.532 1.532 0 01-2.287-.947zM10 13a3 3 0 100-6 3 3 0 000 6z"
              clip-rule="evenodd"
            >
            </path>
          </svg>
        </a>
        <div
          id="tooltip-settings"
          role="tooltip"
          class="inline-block absolute invisible z-10 py-2 px-3 text-sm font-medium text-white bg-gray-900 rounded-lg shadow-sm opacity-0 transition-opacity duration-300 tooltip"
        >
          Settings page
          <div class="tooltip-arrow" data-popper-arrow></div>
        </div>
        <a
          href="/sign-out"
          data-tooltip-target="tooltip-settings"
          class="inline-flex justify-center p-2 text-gray-500 rounded cursor-pointer dark:text-gray-400 dark:hover:text-white hover:text-gray-900 hover:bg-customBackground_header dark:hover:bg-gray-600"
        >
          Logout
        </a>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
