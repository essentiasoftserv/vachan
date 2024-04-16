defmodule VachanWeb.DashLive do
  use VachanWeb, :live_view
  use Phoenix.LiveView, layout: false

  def render(assigns) do
    ~H"""
    <body class="w-full text-sm	bg-customBackground">
      <div>
        <header class="mb-14">
          <nav class="border-gray-200 mx-12 py-2.5">
            <div class="flex flex-wrap justify-between items-center max-w-screen-xl">
              <div class="w-40">
                <a href="https://vaaak.com" class="flex items-center">
                  <img
                    src="/images/vaak-logo.svg"
                    class="mr-3 sm:h-24 w-full h-auto"
                    alt="Vaak Logo"
                  />
                </a>
              </div>
              <div class="flex items-center lg:order-2">
                <a href="https://sign-in" class="hover:underline me-4 md:me-6">Login</a>
                <a href="https://register" class="hover:underline me-4 md:me-6">
                  Register
                </a>
                <button
                  data-collapse-toggle="mobile-menu-2"
                  type="button"
                  class="inline-flex items-center p-2 ml-1 text-sm text-gray-500 rounded-lg lg:hidden hover:bg-gray-100 focus:outline-none focus:ring-2 focus:ring-gray-200 dark:text-gray-400 dark:hover:bg-gray-700 dark:focus:ring-gray-600"
                  aria-controls="mobile-menu-2"
                  aria-expanded="false"
                >
                  <span class="sr-only">Open main menu</span>
                  <svg
                    class="w-6 h-6"
                    fill="currentColor"
                    viewBox="0 0 20 20"
                    xmlns="http://www.w3.org/2000/svg"
                  >
                    <path
                      fill-rule="evenodd"
                      d="M3 5a1 1 0 011-1h12a1 1 0 110 2H4a1 1 0 01-1-1zM3 10a1 1 0 011-1h12a1 1 0 110 2H4a1 1 0 01-1-1zM3 15a1 1 0 011-1h12a1 1 0 110 2H4a1 1 0 01-1-1z"
                      clip-rule="evenodd"
                    >
                    </path>
                  </svg>
                  <svg
                    class="hidden w-6 h-6"
                    fill="currentColor"
                    viewBox="0 0 20 20"
                    xmlns="http://www.w3.org/2000/svg"
                  >
                    <path
                      fill-rule="evenodd"
                      d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z"
                      clip-rule="evenodd"
                    >
                    </path>
                  </svg>
                </button>
              </div>
              <div
                class="hidden justify-between items-center w-full lg:flex lg:w-auto lg:order-1"
                id="mobile-menu-2"
              >
                <ul class="flex flex-col mt-4 font-medium lg:flex-row lg:space-x-8 lg:mt-0">
                  <li></li>
                </ul>
              </div>
            </div>
          </nav>
        </header>
        <div>
          <div class="m-auto w-4/6">
            <p class="text-center mb-10 text-3xl font-bold">Coming soon!</p>
            <p class="text-center mb-10 text-2xl font-bold">
              Your Email Marketing  Needs Simplified
            </p>
            <p class="mb-5">
              Welcome to Vaaak – where your campaigns soar to new heights! Engage, captivate, and convert with our powerful suite of email marketing tools. Create stunning campaigns effortlessly, segment your audience with precision, and track your success in real-time.
            </p>
          </div>
          <div class="mt-32 mb-18">
            <p class="text-center mb-4 text-3xl font-bold">Let us know how can we help you?</p>
            <form class="mx-auto mt-10 w-1/2">
              <div class="grid md:grid-cols-2 md:gap-6">
                <div class="relative z-0 w-full mb-5 group">
                  <input
                    type="text"
                    name="floating_full_name"
                    id="floating_full_name"
                    class="block py-2.5 px-0 w-full text-sm  bg-transparent border-0 border-b-2 border-gray-300 appearance-none dark:text-white dark:border-gray-600 dark:focus:border-gray-500 focus:outline-none focus:ring-0 focus:border-gray-600 peer"
                    placeholder=" Full Name"
                    required
                  />
                </div>
                <div class="relative z-0 w-full mb-5 group">
                  <input
                    type="email"
                    name="floating_email"
                    id="floating_email"
                    class="block py-2.5 px-0 w-full text-sm  bg-transparent border-0 border-b-2 border-gray-300 appearance-none dark:text-white dark:border-gray-600 dark:focus:border-gray-500 focus:outline-none focus:ring-0 focus:border-gray-600 peer"
                    placeholder="Email"
                    required
                  />
                </div>
              </div>
              <div class="relative z-0 w-full mb-5 group">
                <input
                  type="tel"
                  pattern="[7-9]{1}[0-9]{9}"
                  name="floating_phone"
                  id="floating_phone"
                  class="block py-2.5 px-0 w-full text-sm  bg-transparent border-0 border-b-2 border-gray-300 appearance-none dark:text-white dark:border-gray-600 dark:focus:border-gray-500 focus:outline-none focus:ring-0 focus:border-gray-600 peer"
                  placeholder="Phone number"
                />
              </div>
              <div class="relative z-0 w-full mb-5 group">
                <input
                  type="text"
                  name="floating_message"
                  id="message"
                  class="block py-2.5 px-0 w-full text-sm  bg-transparent border-0 border-b-2 border-gray-300 appearance-none dark:text-white dark:border-gray-600 dark:focus:border-gray-500 focus:outline-none focus:ring-0 focus:border-gray-600 peer"
                  placeholder="Message "
                />
              </div>
              <div class="mt-8 text-center">
                <button
                  type="submit"
                  class="text-white text-center bg-black hover:bg-gray-900 focus:ring-4 focus:outline-none focus:ring-blue-300 font-medium rounded-lg text-sm w-full sm:w-auto px-5 py-2.5 text-center dark:bg-blue-600 dark:hover:bg-blue-700 dark:focus:ring-blue-800"
                >
                  Submit
                </button>
              </div>
            </form>
          </div>
        </div>
        <footer class="">
          <div class="w-full mx-auto p-e4 md:py-8">
            <div class="sm:flex sm:items-center sm:justify-between mx-12">
              <div class="w-40">
                <a href="https://vaaak.com" class="flex items-center">
                  <img
                    src="/images/vaak-logo.svg"
                    class="mr-3 sm:h-24 w-full h-auto"
                    alt="Vaak Logo"
                  />
                </a>
              </div>
              <ul class="flex flex-wrap items-center mb-6 text-sm font-medium text-gray-500 sm:mb-0 dark:text-gray-400">
                <li>
                  <a href="#" class="hover:underline me-4 md:me-6">Privacy Policy</a>
                </li>
                <li>
                  <a href="#" class="hover:underline me-4 md:me-6">Terms & Conditions</a>
                </li>
              </ul>
            </div>
            <hr class="my-4 border-gray-300 sm:mx-auto dark:border-gray-700 lg:my-6" />

            <div class="mx-12  md:flex md:items-center md:justify-between">
              <span class="text-sm text-gray-500 dark:text-gray-300 sm:text-center">
                © 2024 <a href="https://vaaak.com/">Essentia Softserv LLP.</a>. All Rights Reserved.
              </span>
              <div class="flex mt-4 sm:justify-center md:mt-0 space-x-5 rtl:space-x-reverse">
                <ul class="flex justify-center mt-5 space-x-5">
                  <%!-- <li>
                    <a
                      href="https://github.com/"
                      target="_blank"
                      class="text-gray-500 hover:text-gray-900 dark:hover:text-white dark:text-gray-400"
                    >
                      <svg class="w-6 h-6" fill="currentColor" viewBox="0 0 24 24" aria-hidden="true">
                        <path
                          fill-rule="evenodd"
                          d="M12 2C6.477 2 2 6.484 2 12.017c0 4.425 2.865 8.18 6.839 9.504.5.092.682-.217.682-.483 0-.237-.008-.868-.013-1.703-2.782.605-3.369-1.343-3.369-1.343-.454-1.158-1.11-1.466-1.11-1.466-.908-.62.069-.608.069-.608 1.003.07 1.531 1.032 1.531 1.032.892 1.53 2.341 1.088 2.91.832.092-.647.35-1.088.636-1.338-2.22-.253-4.555-1.113-4.555-4.951 0-1.093.39-1.988 1.029-2.688-.103-.253-.446-1.272.098-2.65 0 0 .84-.27 2.75 1.026A9.564 9.564 0 0112 6.844c.85.004 1.705.115 2.504.337 1.909-1.296 2.747-1.027 2.747-1.027.546 1.379.202 2.398.1 2.651.64.7 1.028 1.595 1.028 2.688 0 3.848-2.339 4.695-4.566 4.943.359.309.678.92.678 1.855 0 1.338-.012 2.419-.012 2.747 0 .268.18.58.688.482A10.019 10.019 0 0022 12.017C22 6.484 17.522 2 12 2z"
                          clip-rule="evenodd"
                        >
                        </path>
                      </svg>
                    </a>
                  </li> --%>
                  <li>
                    <a
                      href="https://www.linkedin.com/company/vaaak/"
                      target="_blank"
                      class="text-gray-500 hover:text-gray-900 dark:hover:text-white dark:text-gray-400"
                    >
                      <svg
                        xmlns="http://www.w3.org/2000/svg"
                        class="w-5 h-5"
                        viewBox="0 0 24 24"
                        fill="currentColor"
                      >
                        <path d="M5.372 24H.396V7.976h4.976V24ZM2.882 5.79C1.29 5.79 0 4.474 0 2.883a2.882 2.882 0 1 1 5.763 0c0 1.59-1.29 2.909-2.881 2.909ZM23.995 24H19.03v-7.8c0-1.86-.038-4.243-2.587-4.243-2.587 0-2.984 2.02-2.984 4.109V24H8.49V7.976h4.772v2.186h.07c.664-1.259 2.287-2.587 4.708-2.587 5.035 0 5.961 3.316 5.961 7.623V24h-.005Z">
                        </path>
                      </svg>
                    </a>
                  </li>
                </ul>
              </div>
            </div>
          </div>
        </footer>
      </div>
    </body>
    """
  end

  def mount(params, session, socket) do
    {:ok, socket}
  end
end
