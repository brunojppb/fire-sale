defmodule FireSaleWeb.AboutLive do
  use FireSaleWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="px-4 mx-auto sm:px-12 xl:max-w-6xl xl:px-0">
      <div class="text-center">
        <div class="items-center gap-12 lg:flex">
          <div class="md:mx-auto md:w-3/4 lg:ml-0 lg:w-1/2">
            <h1 class="text-5xl font-bold text-center dark:text-white sm:text-6xl lg:text-left lg:text-7xl">
              Welcome to our little Website
            </h1>
            <p class="mt-8 text-lg text-center text-gray-600 dark:text-gray-300 sm:text-xl lg:text-left">
              In the vibrant Northeast region of Brazil, two adventurous souls named Bruno and Rhaisa were united by fate. Their shared thirst for exploration and cultural immersion led them to pack their bags and swap their Frevo tutus for snow boots, moving to the picturesque landscapes of Austria. For eight years, they braved the cold winters, learned to yodel in tune, and even developed a strange affection for sauerkraut. They became so integrated that locals often mistook them for Austrians who just happened to have a year-round tan and a peculiar fondness for tropical rhythms. (Strangely, they never spoke proper Viennese German)
            </p>
            <p class="mt-4 text-lg text-center text-gray-600 dark:text-gray-300 sm:text-xl lg:text-left">
              However, the time has come for a new chapter in their adventure book. Bruno and Rhaisa have decided to trade their snow boots for flamenco shoes and their schnitzels for tapas, as they set their sights on sunny Spain. With their hearts filled with excitement and their suitcases filled with an odd mixture of dirndls and bikinis, they are ready to dive into a sea of paella, conquer the language of Cervantes, and learn the secret art of taking a siesta. After all, who wouldn't want to swap a Wiener Schnitzel for a plate of patatas bravas? And let's be honest, flamenco sounds much more fun than yodeling, doesn't it?
            </p>
          </div>
          <img
            class="mt-12 md:mx-auto md:w-2/3 lg:mt-0 lg:ml-0 lg:w-1/2"
            src={~p"/images/r_b.png"}
            alt="tailus stats and login components"
            width="1865"
            height="1750"
          />
        </div>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    socket
    |> assign(:page_title, "About")
    |> ok()
  end
end
