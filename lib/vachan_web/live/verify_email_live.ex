defmodule VachanWeb.VerifyEmailLive do
  use VachanWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="flex justify-center items-center min-h-screen" style="background-color: rgb(237, 237, 208);">
      <div class="bg-white p-8 rounded shadow-md text-center max-w-md w-full">
        <h1 class="text-3xl font-bold text-red-600 mb-4">Verify Your Email</h1>
        <p class="text-lg">
          You must verify your email before proceeding.
        </p>
        <p class="text-lg mt-4">
          Please check the inbox of the email account you just registered with for the verification link.
        </p>
      </div>
    </div>
    """
  end
end
