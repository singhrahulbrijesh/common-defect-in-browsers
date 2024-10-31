import requests

def get_firefox_bugs():
    base_url = "https://bugzilla.mozilla.org/rest/bug"
    params = {
        "product": "Firefox",
        "include_fields": "id,summary,assigned_to,status, comments",
        "limit": 1,  # You can adjust the limit as needed
    }

    try:
        response = requests.get(base_url, params=params)
        if response.status_code == 200:
            bugs = response.json().get("bugs", [])
            for bug in bugs:
                bug_id = bug.get("id")
                summary = bug.get("summary")
                assigned_to = bug.get("assigned_to")
                status = bug.get("status")
                comment = bug.get("comments")
                print(f"Bug {bug_id}: {summary} (Assigned to: {assigned_to}, Status: {status}), Comment: {comment}")
        else:
            print(f"Error fetching bug data. Status code: {response.status_code}")
    except requests.RequestException as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    get_firefox_bugs()
