FROM elixir:latest

RUN mkdir /app
COPY . /app
WORKDIR /app

ENV SECRET_KEY_BASE 1jTDFGuKmGSrzSY8N/XRoKX62aLqyPVi2rAVPqc88hF1KHrm6JYcP51oEQql3yQJ
ENV MIX_ENV prod

# Install hex package manager
# By using --force, we don’t need to type “Y” to confirm the installation
RUN mix local.hex --force

# Compile the project
RUN mix do compile

RUN mix phx.swagger.generate

EXPOSE 4000

CMD ["mix", "phx.server"]