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
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="size-5">
            <path d="M10 9a3 3 0 1 0 0-6 3 3 0 0 0 0 6ZM6 8a2 2 0 1 1-4 0 2 2 0 0 1 4 0ZM1.49 15.326a.78.78 0 0 1-.358-.442 3 3 0 0 1 4.308-3.516 6.484 6.484 0 0 0-1.905 3.959c-.023.222-.014.442.025.654a4.97 4.97 0 0 1-2.07-.655ZM16.44 15.98a4.97 4.97 0 0 0 2.07-.654.78.78 0 0 0 .357-.442 3 3 0 0 0-4.308-3.517 6.484 6.484 0 0 1 1.907 3.96 2.32 2.32 0 0 1-.026.654ZM18 8a2 2 0 1 1-4 0 2 2 0 0 1 4 0ZM5.304 16.19a.844.844 0 0 1-.277-.71 5 5 0 0 1 9.947 0 .843.843 0 0 1-.277.71A6.975 6.975 0 0 1 10 18a6.974 6.974 0 0 1-4.696-1.81Z" />
          </svg>
          </.menu_item>
        </li>
        <li>
          <.menu_item label="Lists" path={~p"/lists"}>
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="size-5">
          <path fill-rule="evenodd" d="M15.988 3.012A2.25 2.25 0 0 1 18 5.25v6.5A2.25 2.25 0 0 1 15.75 14H13.5V7A2.5 2.5 0 0 0 11 4.5H8.128a2.252 2.252 0 0 1 1.884-1.488A2.25 2.25 0 0 1 12.25 1h1.5a2.25 2.25 0 0 1 2.238 2.012ZM11.5 3.25a.75.75 0 0 1 .75-.75h1.5a.75.75 0 0 1 .75.75v.25h-3v-.25Z" clip-rule="evenodd" />
          <path fill-rule="evenodd" d="M2 7a1 1 0 0 1 1-1h8a1 1 0 0 1 1 1v10a1 1 0 0 1-1 1H3a1 1 0 0 1-1-1V7Zm2 3.25a.75.75 0 0 1 .75-.75h4.5a.75.75 0 0 1 0 1.5h-4.5a.75.75 0 0 1-.75-.75Zm0 3.5a.75.75 0 0 1 .75-.75h4.5a.75.75 0 0 1 0 1.5h-4.5a.75.75 0 0 1-.75-.75Z" clip-rule="evenodd" />
        </svg>
          </.menu_item>
        </li>
        <li>
          <.menu_item label="Sender Profiles" path={~p"/sender-profiles"}>
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="size-5">
          <path fill-rule="evenodd" d="M18 10a8 8 0 1 1-16 0 8 8 0 0 1 16 0Zm-5.5-2.5a2.5 2.5 0 1 1-5 0 2.5 2.5 0 0 1 5 0ZM10 12a5.99 5.99 0 0 0-4.793 2.39A6.483 6.483 0 0 0 10 16.5a6.483 6.483 0 0 0 4.793-2.11A5.99 5.99 0 0 0 10 12Z" clip-rule="evenodd" />
        </svg>

          </.menu_item>
        </li>
        <li>
          <.menu_item label="Campaigns" path={~p"/campaigns"}>
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="size-5">
          <path d="M10 2a.75.75 0 0 1 .75.75v5.59l1.95-2.1a.75.75 0 1 1 1.1 1.02l-3.25 3.5a.75.75 0 0 1-1.1 0L6.2 7.26a.75.75 0 1 1 1.1-1.02l1.95 2.1V2.75A.75.75 0 0 1 10 2Z" />
          <path d="M5.273 4.5a1.25 1.25 0 0 0-1.205.918l-1.523 5.52c-.006.02-.01.041-.015.062H6a1 1 0 0 1 .894.553l.448.894a1 1 0 0 0 .894.553h3.438a1 1 0 0 0 .86-.49l.606-1.02A1 1 0 0 1 14 11h3.47a1.318 1.318 0 0 0-.015-.062l-1.523-5.52a1.25 1.25 0 0 0-1.205-.918h-.977a.75.75 0 0 1 0-1.5h.977a2.75 2.75 0 0 1 2.651 2.019l1.523 5.52c.066.239.099.485.099.732V15a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2v-3.73c0-.246.033-.492.099-.73l1.523-5.521A2.75 2.75 0 0 1 5.273 3h.977a.75.75 0 0 1 0 1.5h-.977Z" />
        </svg>
          </.menu_item>
        </li>
      </ul>
      <div class="hidden absolute bottom-0 left-0 justify-center p-4 space-x-4 w-full lg:flex bg-customBackground dark:bg-gray-800 z-20">
        <a
          href="#"
          class="inline-flex justify-center p-2 text-gray-500 rounded cursor-pointer dark:text-gray-400 hover:text-gray-900 dark:hover:text-white hover:bg-customBackground_header dark:hover:bg-gray-600"
        >
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" class="size-6">
            <path d="M18.75 12.75h1.5a.75.75 0 0 0 0-1.5h-1.5a.75.75 0 0 0 0 1.5ZM12 6a.75.75 0 0 1 .75-.75h7.5a.75.75 0 0 1 0 1.5h-7.5A.75.75 0 0 1 12 6ZM12 18a.75.75 0 0 1 .75-.75h7.5a.75.75 0 0 1 0 1.5h-7.5A.75.75 0 0 1 12 18ZM3.75 6.75h1.5a.75.75 0 1 0 0-1.5h-1.5a.75.75 0 0 0 0 1.5ZM5.25 18.75h-1.5a.75.75 0 0 1 0-1.5h1.5a.75.75 0 0 1 0 1.5ZM3 12a.75.75 0 0 1 .75-.75h7.5a.75.75 0 0 1 0 1.5h-7.5A.75.75 0 0 1 3 12ZM9 3.75a2.25 2.25 0 1 0 0 4.5 2.25 2.25 0 0 0 0-4.5ZM12.75 12a2.25 2.25 0 1 1 4.5 0 2.25 2.25 0 0 1-4.5 0ZM9 15.75a2.25 2.25 0 1 0 0 4.5 2.25 2.25 0 0 0 0-4.5Z" />
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
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
