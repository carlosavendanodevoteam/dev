application: tldd {
  label: "tldd"
  url: "https://storage.googleapis.com/tldd-frontend/bundle.js"
  entitlements: {
    use_clipboard: yes
    use_form_submit: yes
    external_api_urls: ["https://vertex-dashboards-2w54ohrt4q-uc.a.run.app", "https://localhost:8080"]
    global_user_attributes: ["looker_hackathon_vertexai_tldd_api"]
  }
}

# This project

project_name: "carlos-training-looker"

# The project to import
local_dependency: {
  project: "pruebas_looker_sheila_dev"
}
