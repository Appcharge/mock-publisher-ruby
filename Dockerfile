# Use an official Ruby runtime as a parent image
FROM ruby:3

# Set the working directory to /app
WORKDIR /app

# Copy the Gemfile and Gemfile.lock into the container and install dependencies
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy the rest of the application code into the container
COPY . .

# Set the environment variable for the application
ENV APP_ENV production

# Expose port 8080
EXPOSE 8080

# Start the application
CMD ["ruby", "app.rb"]