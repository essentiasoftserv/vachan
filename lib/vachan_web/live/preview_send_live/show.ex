#  defmodule VachanWeb.PreviewSendLive.Show do
#   use Phoenix.LiveView

#    def mount(_params, _session, socket) do
#      {:ok, assign(socket, :page_title, "Preview Send Show")}
#    end

#     def render(assigns) do
#       ~H"""
#       <h1><%= @page_title  %></h1>

#       """
#     end

#   end


defmodule VachanWeb.PreviewSendLive.Show do
  use Phoenix.LiveView

    def mount(_params, _session, socket) do



     # Assigning sample data for the preview page
     {:ok,
      socket

      |> assign(:subject, "Your campaign subject here")
      |> assign(:variables, %{"name" => "John Doe", "date" => "2024-10-21"})


      |> assign(:body, "This is the body content of your campaign preview.")
      |> assign(:list, "Customer List 2024")
      |> assign(:people_count, 1500)
      |> assign(:profile_name, "Campaign Profile")
      |> assign(:sender_name, "Jane Doe")
      |> assign(:sender_email, "jane.doe@example.com")
      |> assign(:smtp_username, "smtp_user")
     |> assign(:smtp_hostname, "smtp.example.com")
     |> assign(:smtp_port, 587)}
   end


  def render(assigns) do
    ~H"""
    <div class="container mx-auto p-6 space-y-6">
      <!-- Content Section -->
      <div class="border p-6 rounded-lg shadow-sm">
        <h1 class="text-3xl font-bold mb-4">Content</h1>
        <div class="space-y-4">
          <div class="border p-4 rounded-lg bg-gray-100">
            <label class="font-semibold">Subject:</label>
            <p><%= @subject %></p>
          </div>
          <div class="border p-4 rounded-lg bg-gray-100">
            <label class="font-semibold">Variables:</label>
            <ul>
              <%= for {key, value} <- @variables do %>
                <li><strong><%= key %>:</strong> <%= value %></li>
              <% end %>
            </ul>
          </div>
          <div class="border p-4 rounded-lg bg-gray-100">

            <label class="font-semibold">Body:</label>
            <p><%= @body %></p>
          </div>
          </div>

      </div>

      <!-- Contacts List Section -->
      <div class="border p-6 rounded-lg shadow-sm">
        <h1 class="text-3xl font-bold mb-4">Contacts List</h1>
        <div class="space-y-4">
          <div class="border p-4 rounded-lg bg-gray-100">
            <label class="font-semibold">List:</label>
            <p><%= @list %></p>
          </div>
          <div class="border p-4 rounded-lg bg-gray-100">
            <label class="font-semibold">People Count:</label>
            <p><%= @people_count %></p>
          </div>
        </div>
      </div>

      <!-- Credentials Section -->
      <div class="border p-6 rounded-lg shadow-sm">
        <h1 class="text-3xl font-bold mb-4">Credentials</h1>
        <div class="space-y-4">
          <div class="border p-4 rounded-lg bg-gray-100">
            <label class="font-semibold">Profile Name:</label>
            <p><%= @profile_name %></p>
          </div>
          <div class="border p-4 rounded-lg bg-gray-100">
            <label class="font-semibold">Sender's Name:</label>
            <p><%= @sender_name %></p>
          </div>
          <div class="border p-4 rounded-lg bg-gray-100">
            <label class="font-semibold">Sender's Email:</label>
            <p><%= @sender_email %></p>
          </div>
          <div class="border p-4 rounded-lg bg-gray-100">
            <label class="font-semibold">SMTP Username:</label>
            <p><%= @smtp_username %></p>
          </div>
          <div class="border p-4 rounded-lg bg-gray-100">
            <label class="font-semibold">SMTP Hostname:</label>
            <p><%= @smtp_hostname %></p>
          </div>
          <div class="border p-4 rounded-lg bg-gray-100">
            <label class="font-semibold">SMTP Port:</label>
            <p><%= @smtp_port %></p>
          </div>
        </div>
      </div>



       <!-- Buttons Section -->
      <div class="flex justify-end space-x-4 mt-6">
        <%!-- <button phx-click="back_to_editing" class="bg-blue-500 hover:bg-gray-600 text-white font-semibold py-2 px-4 rounded">
          Back To Editing
        </button> --%>

   <button onclick="window.history.back()" class="bg-blue-500 hover:bg-gray-600 text-white font-semibold py-2 px-4 rounded">
   Back To Editing
   </button>



  <%!-- <div class="flex justify-end space-x-4 mt-6">
  <.button phx-click={JS.navigate(~p"/campaigns/#{@campaign.id}/builder")}>
    Back To Editing
  </.button>
</div> --%>

        <button phx-click="send_campaign" class="bg-blue-500 hover:bg-blue-600 text-white font-semibold py-2 px-4 rounded">
          Send
        </button>
      </div>
      </div>


        """
  end

end
