using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;


public class PlayerController : MonoBehaviour
{

    //Set speed of player
    public static float verSpeed = 20.0f;
    public static float horSpeed = 16.0f;
    //mouse speed
    public static float sensitivity = 5.0f;
    public static float smoothing = 2.0f;
    private Vector2 mouseLook; //value of mouse's x and y rotation
    private Vector2 smoothV; //velocity of mouse

    float opacity = 0.5f;

    GameObject emptyParent;
    public GameObject water;
    public GameObject jb;

    // Start is called before the first frame update
    void Start()
    {
        emptyParent = this.transform.parent.gameObject;
    }

    // Update is called once per frame
    void Update()
    {
        Cursor.lockState = CursorLockMode.Locked; // Hide mouse
        var md = new Vector2(Input.GetAxisRaw("Mouse X"), Input.GetAxisRaw("Mouse Y")); //input
        md = Vector2.Scale(md, new Vector2(sensitivity * smoothing, sensitivity * 2 / 3 * smoothing));
        smoothV.x = Mathf.Lerp(smoothV.x, md.x, 1f / smoothing);
        smoothV.y = Mathf.Lerp(smoothV.y, md.y, 1f / smoothing);
        mouseLook += smoothV;
        //Rotate view
        transform.localRotation = Quaternion.AngleAxis(-mouseLook.y, Vector3.right);
        emptyParent.transform.localRotation = Quaternion.AngleAxis(mouseLook.x, emptyParent.transform.up);

        float translation = Input.GetAxis("Vertical") * verSpeed; //y input
        float straffe = Input.GetAxis("Horizontal") * horSpeed; //x input
        translation *= Time.deltaTime; //calculate distance
        straffe *= Time.deltaTime;
        translation = Mathf.Clamp(translation, translation / 2, translation);
        emptyParent.transform.Translate(straffe, 0, translation);

        if (Input.GetKey(KeyCode.Q) && water.transform.position.y < -2.5)
            water.transform.Translate(new Vector3(0, 0.1f, 0));
        if (Input.GetKey(KeyCode.E) && water.transform.position.y > -13)
            water.transform.Translate(new Vector3(0, -0.1f, 0));

        if (Input.GetKeyDown(KeyCode.Z))
            jb.GetComponent<Renderer>().material.SetInt("_DeformationType", 0);
        else if (Input.GetKeyDown(KeyCode.X))
            jb.GetComponent<Renderer>().material.SetInt("_DeformationType", 1);
        else if (Input.GetKeyDown(KeyCode.C))
            jb.GetComponent<Renderer>().material.SetInt("_DeformationType", 2);

        if(Input.GetKeyDown(KeyCode.LeftArrow))
            SceneManager.LoadScene("SampleScene");

        if (Input.GetKeyDown(KeyCode.R)&&opacity<1)
        {
            opacity += 0.1f;
            water.GetComponent<Renderer>().material.SetFloat("_Opacity", opacity);
        }
        if (Input.GetKeyDown(KeyCode.F) && opacity > 0)
        {
            opacity -= 0.1f;
            water.GetComponent<Renderer>().material.SetFloat("_Opacity", opacity);
        }
    }
}
