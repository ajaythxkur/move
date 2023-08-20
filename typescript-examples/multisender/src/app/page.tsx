"use client"
import { useFormik } from "formik"
import * as Yup from "yup"
export default function Home() {
  const formik = useFormik({
    initialValues: {
      address: '',
      amount: ''
    },
    validationSchema: Yup.object({
      address: Yup.string().required("Address needed"),
      amount: Yup.number().required("Amount needed")
    }),
    onSubmit: async (values) => {
      console.log(values)
    }
  })
  const { handleSubmit, handleChange, values, errors, touched } = formik;
  return (
    <section className='main-section'>
      <div className="container-fluid">
        <div className="row justify-content-center">
          <div className="col-md-6 col-lg-4">
            <div className="add-form p-3">
              <form onSubmit={handleSubmit}>
                <div className="mb-3">
                  <div className="input-group">
                    <span className="input-group-text">@</span>
                    <input type="text" name="address" className="form-control" placeholder="Aptos address" value={values.address} onChange={handleChange} />
                  </div>
                </div>
                <div className="mb-3">
                  <div className="input-group mb-3">
                    <span className="input-group-text">@</span>
                    <input type="text" name="amount" className="form-control" placeholder="Amount (APT)" value={values.address} onChange={handleChange} />
                  </div>
                </div>
                <input type="submit" value="Add" className="btn" />
              </form>
            </div>
          </div>
          <hr />
          <div className="col-md-12">
            <div className="mb-3 d-md-flex gap-3 align-items-center justify-content-between">
              <p className="mb-2 mb-md-0">232 Apt</p>
              <p className="mb-2 mb-md-0">232 Apt</p>
              <button className="p-0 border-0 btn">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="var(--text-red)"><path d="M6 7H5v13a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2V7H6zm4 12H8v-9h2v9zm6 0h-2v-9h2v9zm.618-15L15 2H9L7.382 4H3v2h18V4z"></path></svg>
              </button>
            </div>
          </div>
          <hr />
        </div>
      </div>
    </section>
  )
}
