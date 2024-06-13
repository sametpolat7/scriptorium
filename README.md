# Scriptorium

Scriptorium is an article blog. It is a website where users can login and write, read, manage and interaction with articles. It is built with Ruby on Rails. Styling is provided by TailwindCSS. Postgresql is used for the database and Devise for authentication. 

Live: <a href="https://scriptorium.onrender.com/" target="_blank">https://scriptorium.onrender.com/</a>

## Features
- Rich Editor for Articles
- CRUD on Articles and Comments
- Validations at Model-Level
- Authentication and Authorization with Devise
- GitHub Omniauth
- Internationalization with I18n (Turkish, English)
- API support via `/api/articles`
- Article search input (Also tag: tag_name)
- Simple UI, Effective UX

## Dependencies and Versions
- `Ruby 3.2.4`
- `Rails 7.1.3`
- `pg 1.1`
- `tailwindcss-rails 2.6`
- `local_time 3.0.2`
- `Devise 4.9.4`
- `active_model_serializers 0.10.14`
- `rails-i18n 7.0.9`
- `omniauth-github 2.0`
- `omniauth-rails_csrf_protection 1.0.2`